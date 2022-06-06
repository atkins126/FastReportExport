library isapi;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils, System.Classes, Horse, Horse.StaticFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, frxClass,
  FRExport, FRExport.Interfaces, FRExport.Interfaces.Providers, FRExport.Types, //FRExport Classes
  Utils in '..\Utils\Utils.pas';

{$R *.res}

begin
  THorse.Use('/', HorseStaticFile(TUtils.PathApp, ['']));

  THorse.Get('ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  THorse.Get('export',
    procedure(pReq: THorseRequest; pRes: THorseResponse; pNext: TProc)
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
                lfrxMemoView.Memo.Text := 'ISAPI HORSE';
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
    end);

  THorse.Listen;
end.
