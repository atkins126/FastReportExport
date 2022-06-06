unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  frxClass, Vcl.StdCtrls, frxDBSet, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, frxExportBaseDialog, frxExportCSV;

type
  TfrmMain = class(TForm)
    frxReport: TfrxReport;
    qryCliente: TFDQuery;
    conFastReportExport: TFDConnection;
    dsCliente: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Button2: TButton;
    btnExportar: TButton;
    frxDataSet: TfrxDBDataset;
    procedure btnExportarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Utils, FRExport, FRExport.Types, FRExport.Interfaces.Providers, System.Generics.Collections;

{$R *.dfm}

procedure TfrmMain.btnExportarClick(Sender: TObject);
var
  lFRExportPDF: IFRExportPDF;
  lFRExportHTML: IFRExportHTML;
  lFRExportPNG: IFRExportPNG;
  lFileStream: TFileStream;
  lFileExport: string;
begin

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
        SetDataSet(qryCliente, 'DataSetCliente').
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
            lfrxMemoView.Memo.Text := 'VCL';
          end;
        end).
        Execute;
  except
    on E: Exception do
    begin
      if E is EFRExport then
        ShowMessage(E.ToString)
      else
        ShowMessage(E.Message);
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
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  conFastReportExport.Open();

  qryCliente.Close;
  qryCliente.Open();

  btnExportar.Enabled := True;
end;

end.
