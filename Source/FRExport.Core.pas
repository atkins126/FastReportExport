{******************************************************************************}
{                                                                              }
{           FRExport                                                           }
{                                                                              }
{           Copyright (C) Antônio José Medeiros Schneider Júnior               }
{                                                                              }
{           https://github.com/antoniojmsjr/FastReportExport                   }
{                                                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit FRExport.Core;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, Vcl.ExtCtrls,
  FireDAC.Comp.Client, frxClass, frxExportPDF, frxExportHTML, frxExportImage,
  frxExportCSV, frxDBSet, frxChart, frxBarcode, frxOLE, frxRich, frxGaugeView,
  frxCross, FRExport.Types, FRExport.Interfaces, FRExport.Interfaces.Providers;

type
  TFRExportDataSets = class;
  TFRExportProviders = class;
  TFRExportExecute = class;

  {$REGION 'TFRExportCustom'}
  TFRExportCustom = class(TInterfacedObject, IFRExport)
  private
    { private declarations }
    FFrxReport: TfrxReport;
    FFRExportExecuteInterf: IFRExportExecute;
    FFRExportDataSetsInterf: IFRExportDataSets;
    FFRExportProvidersInterf: IFRExportProviders;
    FFRExportProviders: TFRExportProviders;

    function GetFRExportExecute: IFRExportExecute;
    function GetExportDataSets: IFRExportDataSets;
    function GetExportProviders: IFRExportProviders;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
  end;
  {$ENDREGION}

  {$REGION 'TFRExportDataSets'}
  TFRExportDataSets = class sealed(TInterfacedObject, IFRExportDataSets)
  private
    { private declarations }
    [Weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    FFRExport: IFRExport;
    FFrxReport: TfrxReport;
    FListFrxDBDataset: TObjectList<TfrxDBDataset>;
    function GetEnd: IFRExport;
    function SetDataSet(pDataSet: TFDQuery; const pFrxDBDatasetUserName: string): IFRExportDataSets; overload;
    function SetDataSet(pDataSet: TfrxDBDataset): IFRExportDataSets; overload;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(pParent: IFRExport; pFrxReport: TfrxReport);
    destructor Destroy; override;
  end;
  {$ENDREGION}

  {$REGION 'TFRExportProviders'}
  TFRExportProviders = class sealed(TInterfacedObject, IFRExportProviders)
  private
    { private declarations }
    [Weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    FFRExport: IFRExport;
    FFrxReport: TfrxReport;
    FListProviders: TList<IFRExportProvider>;

    function GetEnd: IFRExport;
    function SetProvider(pProvider: IFRExportProvider): IFRExportProviders;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(pParent: IFRExport; pFrxReport: TfrxReport);
    destructor Destroy; override;
    property ListProviders: TList<IFRExportProvider> read FListProviders;
  end;
  {$ENDREGION}

  {$REGION 'TFRExportExecute'}
  TFRExportExecute = class sealed(TInterfacedObject, IFRExportExecute)
  private
    { private declarations }
    [Weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    FFRExport: IFRExport;
    FFRExportProviders: TFRExportProviders;
    FFrxReport: TfrxReport;
    function SetFileReport(const pFileName: string): IFRExportExecute;
    function Report(const pCallbackReport: TFRExportReportCallback): IFRExportExecute;
    procedure Execute;
    procedure ExportProvider(pProvider: IFRExportProvider);
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(pParent: IFRExport; pFRExportProviders: TFRExportProviders;
                       pFrxReport: TfrxReport);
  end;
  {$ENDREGION}

  {$REGION 'TFRExportProviderCustom'}
  TFRExportProviderCustom = class(TInterfacedObject, IFRExportProvider)
  private
    { private declarations }
    function GetfrxCustomExportFilter: TfrxCustomExportFilter; virtual; abstract;
    function GetName: string; virtual; abstract;
    function GetStream: TStream;
  protected
    { protected declarations }
    FStream: TStream;
    procedure InitFrxExportFilter(pfrxCustomExportFilter: TfrxCustomExportFilter);
  public
    { public declarations }
    constructor Create; virtual;
    destructor Destroy; override;
  end;
  {$ENDREGION}

  {$REGION 'TFRExportProviderPDFCustom'}
  TFRExportProviderPDFCustom = class(TFRExportProviderCustom, IFRExportPDF)
  private
    { private declarations }
    FFrxPDFExport: TfrxPDFExport;

    function GetfrxCustomExportFilter: TfrxCustomExportFilter; override;
    function GetName: string; override;
    function GetfrxPDF: TfrxPDFExport;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create; override;
    destructor Destroy; override;
    class function New: IFRExportPDF;
  end;
  {$ENDREGION}

  {$REGION 'TFRExportProviderHTMLCustom'}
  TFRExportProviderHTMLCustom = class(TFRExportProviderCustom, IFRExportHTML)
  private
    { private declarations }
    FFrxHTMLExport: TfrxHTMLExport;

    function GetfrxCustomExportFilter: TfrxCustomExportFilter; override;
    function GetName: string; override;
    function GetfrxHTML: TfrxHTMLExport;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create; override;
    destructor Destroy; override;
    class function New: IFRExportHTML;
  end;
  {$ENDREGION}

  {$REGION 'TFRExportProviderPNGCustom'}
  TFRExportProviderPNGCustom = class(TFRExportProviderCustom, IFRExportPNG)
  private
    { private declarations }
    FFrxPNGExport: TfrxPNGExport;

    function GetfrxCustomExportFilter: TfrxCustomExportFilter; override;
    function GetName: string; override;
    function GetfrxPNG: TfrxPNGExport;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create; override;
    destructor Destroy; override;
    class function New: IFRExportPNG;
  end;
  {$ENDREGION}

  {$REGION 'TFRExportProviderCSVCustom'}
  TFRExportProviderCSVCustom = class(TFRExportProviderCustom, IFRExportCSV)
  private
    { private declarations }
    FFrxCSVExport: TfrxCSVExport;

    function GetfrxCustomExportFilter: TfrxCustomExportFilter; override;
    function GetName: string; override;
    function GetfrxCSV: TfrxCSVExport;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create; override;
    destructor Destroy; override;
    class function New: IFRExportCSV;
  end;
  {$ENDREGION}

implementation

{$REGION 'TFRExportCustom'}
constructor TFRExportCustom.Create;
begin
  FFrxReport := TfrxReport.Create(nil);

  FFRExportDataSetsInterf := TFRExportDataSets.Create(Self, FFrxReport);
  FFRExportProviders := TFRExportProviders.Create(Self, FFrxReport);
  FFRExportProvidersInterf := FFRExportProviders;
  FFRExportExecuteInterf := TFRExportExecute.Create(Self, FFRExportProviders, FFrxReport);
end;

destructor TFRExportCustom.Destroy;
begin
  FFrxReport.Free;
  inherited Destroy;
end;

function TFRExportCustom.GetFRExportExecute: IFRExportExecute;
begin
  Result := FFRExportExecuteInterf;
end;

function TFRExportCustom.GetExportDataSets: IFRExportDataSets;
begin
  Result := FFRExportDataSetsInterf;
end;

function TFRExportCustom.GetExportProviders: IFRExportProviders;
begin
  Result := FFRExportProvidersInterf
end;
{$ENDREGION}

{$REGION 'TFRExportDataSets'}
constructor TFRExportDataSets.Create(pParent: IFRExport;
  pFrxReport: TfrxReport);
begin
  FFRExport := pParent;
  FFrxReport := pFrxReport;
  FFrxReport.DataSets.Clear;

  FListFrxDBDataset := TObjectList<TfrxDBDataset>.Create(True);
end;

destructor TFRExportDataSets.Destroy;
begin
  FListFrxDBDataset.Clear;
  FListFrxDBDataset.Free;
  inherited Destroy;
end;

function TFRExportDataSets.GetEnd: IFRExport;
begin
  Result := FFRExport;
end;

function TFRExportDataSets.SetDataSet(
  pDataSet: TfrxDBDataset): IFRExportDataSets;
begin
  Result := Self;
  FFrxReport.DataSets.Add(pDataSet);
end;

function TFRExportDataSets.SetDataSet(pDataSet: TFDQuery;
  const pFrxDBDatasetUserName: string): IFRExportDataSets;
var
  lFrxDBDataset: TfrxDBDataset;
begin
  Result := Self;

  lFrxDBDataset := TfrxDBDataset.Create(nil);
  lFrxDBDataset.CloseDataSource := False;
  lFrxDBDataset.OpenDataSource := False;
  lFrxDBDataset.UserName := pFrxDBDatasetUserName;
  lFrxDBDataset.DataSet := pDataSet;

  FListFrxDBDataset.Add(lFrxDBDataset);
  FFrxReport.DataSets.Add(lFrxDBDataset);
  FFrxReport.EnabledDataSets.Add(lFrxDBDataset);
end;
{$ENDREGION}

{$REGION 'TFRExportProviders'}
constructor TFRExportProviders.Create(pParent: IFRExport;
  pFrxReport: TfrxReport);
begin
  FFRExport := pParent;
  FFrxReport := pFrxReport;
  FListProviders := TList<IFRExportProvider>.Create;
end;

destructor TFRExportProviders.Destroy;
begin
  FListProviders.Free;
  inherited Destroy;
end;

function TFRExportProviders.GetEnd: IFRExport;
begin
  Result := FFRExport;
end;

function TFRExportProviders.SetProvider(
  pProvider: IFRExportProvider): IFRExportProviders;
begin
  Result := Self;
  FListProviders.Add(pProvider);
end;
{$ENDREGION}

{$REGION 'TFRExportExecute'}
constructor TFRExportExecute.Create(pParent: IFRExport;
  pFRExportProviders: TFRExportProviders; pFrxReport: TfrxReport);
begin
  FFRExport := pParent;
  FFRExportProviders := pFRExportProviders;
  FFrxReport := pFrxReport;
end;

function TFRExportExecute.SetFileReport(
  const pFileName: string): IFRExportExecute;
begin
  Result := Self;

  if pFileName.Trim.IsEmpty then
    raise EFRExportFileReport.Create(pFileName, 'File is empty.');

  if not FileExists(pFileName) then
    raise EFRExportFileReport.Create(pFileName, 'File not found.');

  //CARREGA O FORMULÁRIO NO COMPONENTE
  FFrxReport.LoadFromFile(pFileName);
end;

function TFRExportExecute.Report(
  const pCallbackReport: TFRExportReportCallback): IFRExportExecute;
begin
  Result := Self;

  if Assigned(pCallbackReport) then
    pCallbackReport(FFrxReport);
end;

procedure TFRExportExecute.Execute;
var
  lFRExportProviderInterf: IFRExportProvider;
begin
  //A classe TfrxEngineOptions representa um conjunto de propriedades relacionadas ao mecanismo FastReport. A instância desta classe é armazenada no TfrxReport.EngineOptions

  //Define se o relatório é matricial. Ao definir esta propriedade como True, o relatório pode conter páginas matriciais (TfrxDMPPage) e objetos. Não defina esta propriedade diretamente. Use o item de menu "Arquivo|Novo..." para criar relatórios matriciais.
  FFrxReport.DotMatrixReport := False;

  //A propriedade determina se é necessário utilizar a lista global de DataSet ou a lista de coleção EnabledDataSet do componente TfrxReport. Padrão-Verdadeiro.
  FFrxReport.EngineOptions.UseGlobalDataSetList := False;

  //Preterido (consulte NewSilentMode). "Modo silencioso. Quando ocorrerem erros durante o carregamento ou execução do relatório, nenhuma janela de diálogo será exibida.
  //Todos os erros estarão contidos no TfrxReport. Propriedade de erros. Este modo é útil para aplicativos de servidor. O valor padrão é Falso.
  //FFastReport.EngineOptions.SilentMode := True;

  //Alterne o componente TfrxReport no modo multithread. Desabilita rotinas inseguras como o ciclo ProcessMessages.
  FFrxReport.EngineOptions.EnableThreadSafe := True;

  //Determina se o relatório deve ser salvo no fluxo temporário antes de executar um relatório e restaurá-lo após a conclusão do relatório. O padrão é Verdadeiro.
  FFrxReport.EngineOptions.DestroyForms := False;

  //Defina o comportamento do tratamento de exceções durante a execução do relatório.
  FFrxReport.EngineOptions.NewSilentMode := simSilent;

  FFrxReport.PrintOptions.ShowDialog := False;
  FFrxReport.ShowProgress := False;
  FFrxReport.StoreInDFM := False;
  FFrxReport.ScriptLanguage := 'PascalScript';
  FFrxReport.PreviewOptions.AllowEdit := False;

  //PARA EVITAR O ERRO * Dataset "xxxxxxx" does not exist
  //FFrxReport.LoadFromFile(FFrxReport.FileName);

  if not FFrxReport.PrepareReport then
    raise EFRExportPrepareReport.Create(FFrxReport.Errors); //PEGA OS ERROS GERADO PELO PrepareReport

  //LISTA DE PROVEDORES
  for lFRExportProviderInterf in FFRExportProviders.ListProviders do
  begin
    try
      ExportProvider(lFRExportProviderInterf);
    except
      on E: Exception do
        raise EFRExportProvider.Create(lFRExportProviderInterf.Name, E.Message);
    end;
  end;
end;

procedure TFRExportExecute.ExportProvider(pProvider: IFRExportProvider);
begin
  FFrxReport.Export(pProvider.GetfrxCustomExportFilter);
end;

{$ENDREGION}

{$REGION 'TFRExportProviderCustom'}
constructor TFRExportProviderCustom.Create;
begin
  FStream :=  TMemoryStream.Create;
end;

destructor TFRExportProviderCustom.Destroy;
begin
  if Assigned(FStream) then
    FStream.Free;
  inherited Destroy;
end;

procedure TFRExportProviderCustom.InitFrxExportFilter(
  pfrxCustomExportFilter: TfrxCustomExportFilter);
begin
  pfrxCustomExportFilter.ShowDialog := False;
  pfrxCustomExportFilter.ShowProgress := False;
  pfrxCustomExportFilter.CreationTime := Now;
  pfrxCustomExportFilter.Stream := FStream;
end;

function TFRExportProviderCustom.GetStream: TStream;
begin
  Result := FStream;
end;
{$ENDREGION}

{$REGION 'TFRExportProviderPDFCustom'}
constructor TFRExportProviderPDFCustom.Create;
begin
  inherited Create;
  FFrxPDFExport := TfrxPDFExport.Create(nil);
  FFrxPDFExport.Background := True;
  InitFrxExportFilter(FFrxPDFExport);
end;

class function TFRExportProviderPDFCustom.New: IFRExportPDF;
begin
  Result := Self.Create;
end;

destructor TFRExportProviderPDFCustom.Destroy;
begin
  FFrxPDFExport.Free;
  inherited Destroy;
end;

function TFRExportProviderPDFCustom.GetfrxCustomExportFilter: TfrxCustomExportFilter;
begin
  Result := GetfrxPDF;
end;

function TFRExportProviderPDFCustom.GetfrxPDF: TfrxPDFExport;
begin
  Result := FFrxPDFExport;
end;

function TFRExportProviderPDFCustom.GetName: string;
begin
  Result := 'PDF';
end;
{$ENDREGION}

{$REGION 'TFRExportProviderHTMLCustom'}
constructor TFRExportProviderHTMLCustom.Create;
begin
  inherited Create;
  FFrxHTMLExport := TfrxHTMLExport.Create(nil);
  FFrxHTMLExport.Background := True;
  InitFrxExportFilter(FFrxHTMLExport);
end;

class function TFRExportProviderHTMLCustom.New: IFRExportHTML;
begin
  Result := Self.Create;
end;

destructor TFRExportProviderHTMLCustom.Destroy;
begin
  FFrxHTMLExport.Free;
  inherited Destroy;
end;

function TFRExportProviderHTMLCustom.GetfrxCustomExportFilter: TfrxCustomExportFilter;
begin
  Result := GetfrxHTML;
end;

function TFRExportProviderHTMLCustom.GetfrxHTML: TfrxHTMLExport;
begin
  Result := FFrxHTMLExport;
end;

function TFRExportProviderHTMLCustom.GetName: string;
begin
  Result := 'HTML';
end;
{$ENDREGION}

{$REGION 'TFRExportProviderPNGCustom'}
constructor TFRExportProviderPNGCustom.Create;
begin
  inherited Create;
  FFrxPNGExport := TfrxPNGExport.Create(nil);
  InitFrxExportFilter(FFrxPNGExport);
end;

class function TFRExportProviderPNGCustom.New: IFRExportPNG;
begin
  Result := Self.Create;
end;

destructor TFRExportProviderPNGCustom.Destroy;
begin
  FFrxPNGExport.Free;
  inherited Destroy;
end;

function TFRExportProviderPNGCustom.GetfrxCustomExportFilter: TfrxCustomExportFilter;
begin
  Result := GetfrxPNG;
end;

function TFRExportProviderPNGCustom.GetfrxPNG: TfrxPNGExport;
begin
  Result := FFrxPNGExport;
end;

function TFRExportProviderPNGCustom.GetName: string;
begin
  Result := 'PNG';
end;
{$ENDREGION}

{$REGION 'TFRExportProviderPNGCustom'}
constructor TFRExportProviderCSVCustom.Create;
begin
  inherited Create;
  FFrxCSVExport := TfrxCSVExport.Create(nil);
  InitFrxExportFilter(FFrxCSVExport);
end;

class function TFRExportProviderCSVCustom.New: IFRExportCSV;
begin
  Result := Self.Create;
end;

destructor TFRExportProviderCSVCustom.Destroy;
begin
  FFrxCSVExport.Free;
  inherited Destroy;
end;

function TFRExportProviderCSVCustom.GetfrxCSV: TfrxCSVExport;
begin
  Result := FFrxCSVExport;
end;

function TFRExportProviderCSVCustom.GetfrxCustomExportFilter: TfrxCustomExportFilter;
begin
  Result := GetfrxCSV;
end;

function TFRExportProviderCSVCustom.GetName: string;
begin
  Result := 'CSV';
end;
{$ENDREGION}

end.
