unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Horse,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, frxClass, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    btnStop: TBitBtn;
    btnStart: TBitBtn;
    edtPort: TEdit;
    btnBrowser: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    cbxView: TComboBox;
    procedure FormDestroy(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnBrowserClick(Sender: TObject);
    procedure cbxViewChange(Sender: TObject);
  private
    { Private declarations }
    procedure Status;
    procedure Start;
    procedure Stop;
    procedure ExportFastReport(pReq: THorseRequest; pRes: THorseResponse; pNext: TNextProc);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Winapi.ShellApi, Horse.StaticFiles, Utils, FRExport, FRExport.Types, FRExport.Interfaces.Providers;

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  Start;
  Status;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  Stop;
  Status;
end;

procedure TfrmMain.cbxViewChange(Sender: TObject);
var
  lLink: string;
begin
  lLink := Format('http://localhost:%s/%s', [edtPort.Text, cbxView.Items[cbxView.ItemIndex]]);
  ShellExecute(0, 'OPEN', PChar(lLink), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.btnBrowserClick(Sender: TObject);
var
  lLink: string;
begin
  lLink := Format('http://localhost:%s/export', [edtPort.Text]);
  ShellExecute(0, 'OPEN', PChar(lLink), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if THorse.IsRunning then
    Stop;
end;

procedure TfrmMain.Start;
begin
  THorse.Use('/', HorseStaticFile(TUtils.PathApp, ['']));

  THorse.Get('ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  //CERTO É POST, MAS COMO EXEMPLO PARA VISUALIZAR NO BROWSER VAI SER O GET
  THorse.Get('export', ExportFastreport);

  THorse.Listen(StrToInt(edtPort.Text));
end;

procedure TfrmMain.Status;
begin
  btnStop.Enabled := THorse.IsRunning;
  btnStart.Enabled := not THorse.IsRunning;
  edtPort.Enabled := not THorse.IsRunning;
  btnBrowser.Enabled := THorse.IsRunning;
  cbxView.Enabled := THorse.IsRunning;
end;

procedure TfrmMain.Stop;
begin
  THorse.StopListen;
end;

procedure TfrmMain.ExportFastReport(pReq: THorseRequest; pRes: THorseResponse;
  pNext: TNextProc);
var
  lFDConnection: TFDConnection;
  lQryCliente: TFDQuery;
  lError: string;
  lFRExportPDF: IFRExportPDF;
  lFRExportHTML: IFRExportHTML;
  lFRExportPNG: IFRExportPNG;
  lFileStream: TFileStream;
  lFileExport: string;
begin
  lFDConnection := nil;
  lQryCliente := nil;
  try
    lFDConnection := TFDConnection.Create(nil);
    lQryCliente := TFDQuery.Create(lFDConnection);
    lQryCliente.Connection := lFDConnection;

    //CONEXÃO COM O BANCO DE DADOS DE EXEMPLO
    if not TUtils.ConnectDB('127.0.0.1', TUtils.PathAppFileDB, lFDConnection, lError) then
    begin
      pRes.Send('Erro de conexão: ' + lError).Status(500);
      Exit;
    end;

    //SELECT TABELA CLIENTE
    if not TUtils.QueryOpen(lQryCliente, 'SELECT * FROM CLIENTE', lError) then
    begin
      pRes.Send('Erro de consulta: ' + lError).Status(500);
      Exit;
    end;

    //EXPORT PDF/HTML/PNG

    //PROVIDER PDF
    lFRExportPDF := TFRExportProviderPDF.New;
    lFRExportPDF.frxPDF.Subject := 'Cliente - Delphi';
    lFRExportPDF.frxPDF.Author := 'Antônio José Medeiros Schneider';
    lFRExportPDF.frxPDF.Creator := 'Antônio José Medeiros Schneider';

    //PROVIDER HTML
    lFRExportHTML := TFRExportProviderHTML.New;

    //PROVIDER PNG
    lFRExportPNG := TFRExportProviderPNG.New;

    //CLASSE DE EXPORTAÇÃO
    try
      TFRExport.New.
      DataSets.
        SetDataSet(lQryCliente, 'DataSetCliente').
      &End.
      Providers.
        SetProvider(lFRExportPDF).
        SetProvider(lFRExportHTML).
        SetProvider(lFRExportPNG).
      &End.
      Export.
        SetFileReport(TUtils.PathAppFileReport).
        Report(procedure(pfrxReport: TfrxReport)
        var
          lfrxComponent: TfrxComponent;
          lfrxMemoView: TfrxMemoView absolute lfrxComponent;
        begin
          //CONFIGURAÇÃO DO COMPONENTE
          pfrxReport.ReportOptions.Author := 'Antônio José Medeiros Schneider';

          //PASSAGEM DE PARÂMETRO PARA O RELATÓRIO
          lfrxComponent := pfrxReport.FindObject('mmoProcess');
          if Assigned(lfrxComponent) then
          begin
            lfrxMemoView.Memo.Clear;
            lfrxMemoView.Memo.Text := 'VCL HORSE';
          end;
        end).
        Execute;
    except
      on E: Exception do
      begin
        if E is EFRExport then
          pRes.Send(E.ToString).Status(500)
        else
          pRes.Send(E.Message).Status(500);
        Exit;
      end;
    end;

    //SALVAR PDF
    if Assigned(lFRExportPDF.Stream) then
    begin
      lFileStream := nil;
      try
        lFileExport := Format('%s%s', [TUtils.PathApp, 'Cliente.pdf']);
        lFileStream := TFileStream.Create(lFileExport, fmCreate);
        lFileStream.CopyFrom(lFRExportPDF.Stream, 0);
      finally
        FreeAndNil(lFileStream);
      end;
    end;

    //SALVAR HTML
    if Assigned(lFRExportHTML.Stream) then
    begin
      lFileStream := nil;
      try
        lFileExport := Format('%s%s', [TUtils.PathApp, 'Cliente.html']);
        lFileStream := TFileStream.Create(lFileExport, fmCreate);
        lFileStream.CopyFrom(lFRExportHTML.Stream, 0);
      finally
        lFileStream.Free;
      end;
    end;

    //SALVAR PNG
    if Assigned(lFRExportPNG.Stream) then
    begin
      lFileStream := nil;
      try
        lFileExport := Format('%s%s', [TUtils.PathApp, 'Cliente.png']);
        lFileStream := TFileStream.Create(lFileExport, fmCreate);
        lFileStream.CopyFrom(lFRExportPNG.Stream, 0);
      finally
        lFileStream.Free;
      end;
    end;

    pRes.Send('Ok').Status(200);
  finally
    lQryCliente.Close;
    lFDConnection.Free;
  end;
end;

end.
