object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Exportar Fast Report'
  ClientHeight = 211
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 45
    Width = 520
    Height = 160
    Align = alTop
    DataSource = dsCliente
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATA_NASCIMENTO'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object Button2: TButton
      Left = 15
      Top = 11
      Width = 100
      Height = 25
      Caption = 'Conectar DB'
      TabOrder = 0
      OnClick = Button2Click
    end
    object btnExportar: TButton
      Left = 424
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Exportar'
      Enabled = False
      TabOrder = 1
      OnClick = btnExportarClick
    end
  end
  object frxReport: TfrxReport
    Version = '6.9.15'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 44712.599256608800000000
    ReportOptions.LastChange = 44717.813803298600000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 360
    Top = 8
    Datasets = <
      item
        DataSet = frxDataSet
        DataSetName = 'DataSetCliente'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object pgMain: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 158.740260000000000000
        Width = 718.110700000000000000
        DataSet = frxDataSet
        DataSetName = 'DataSetCliente'
        RowCount = 0
        object qryClienteID: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          DataField = 'ID'
          DataSet = frxDataSet
          DataSetName = 'DataSetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[DataSetCliente."ID"]')
        end
        object qryClienteNOME: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 124.724490000000000000
          Width = 328.819110000000000000
          Height = 18.897650000000000000
          DataField = 'NOME'
          DataSet = frxDataSet
          DataSetName = 'DataSetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[DataSetCliente."NOME"]')
        end
        object qryClienteDATA_NASCIMENTO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 468.661720000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'DATA_NASCIMENTO'
          DataSet = frxDataSet
          DataSetName = 'DataSetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[DataSetCliente."DATA_NASCIMENTO"]')
        end
      end
      object Header1: TfrxHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 113.385900000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'IDENTIFICADOR')
        end
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Left = 124.724490000000000000
          Width = 328.819110000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'NOME')
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 468.661720000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'DATA DE NASCIMENTO')
        end
        object Line1: TfrxLineView
          Align = baWidth
          AllowVectorExport = True
          Top = 18.897650000000000000
          Width = 718.110700000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
      end
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 34.015770000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Date: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 582.047620000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[Date]')
        end
        object Time: TfrxMemoView
          IndexTag = 1
          Align = baRight
          AllowVectorExport = True
          Left = 657.638220000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[Time]')
        end
        object Memo4: TfrxMemoView
          Align = baWidth
          AllowVectorExport = True
          Left = 113.385826770000000000
          Width = 468.661793230000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'CLIENTES')
          ParentFont = False
        end
        object mmoProcess: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Width = 113.385826770000000000
          Height = 34.015770000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'mmoProcess')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 151.181200000000000000
        Top = 241.889920000000000000
        Width = 718.110700000000000000
        object Chart1: TfrxChartView
          AllowVectorExport = True
          Left = 45.354360000000000000
          Width = 132.283550000000000000
          Height = 136.063080000000000000
          HighlightColor = clBlack
          Frame.Typ = []
          Chart = {
            5450463006544368617274054368617274044C656674020003546F7002000557
            696474680390010648656967687403FA00144261636B57616C6C2E50656E2E56
            697369626C65080B4178697356697369626C65080D4672616D652E5669736962
            6C65080656696577334408175669657733444F7074696F6E732E456C65766174
            696F6E033B01185669657733444F7074696F6E732E4F7274686F676F6E616C08
            195669657733444F7074696F6E732E5065727370656374697665020016566965
            7733444F7074696F6E732E526F746174696F6E0368010B56696577334457616C
            6C73080A426576656C4F75746572070662764E6F6E6505436F6C6F720707636C
            57686974650D44656661756C7443616E766173060E54474449506C757343616E
            76617311436F6C6F7250616C65747465496E646578020D000A54506965536572
            6965730753657269657331114D61726B732E466F6E742E48656967687402F70D
            4D61726B732E56697369626C6508144D61726B732E43616C6C6F75742E4C656E
            67746802000D5856616C7565732E4F72646572070B6C6F417363656E64696E67
            0C5956616C7565732E4E616D6506035069650D5956616C7565732E4F72646572
            07066C6F4E6F6E651A4672616D652E496E6E657242727573682E4261636B436F
            6C6F720705636C526564224672616D652E496E6E657242727573682E47726164
            69656E742E456E64436F6C6F720706636C47726179224672616D652E496E6E65
            7242727573682E4772616469656E742E4D6964436F6C6F720707636C57686974
            65244672616D652E496E6E657242727573682E4772616469656E742E53746172
            74436F6C6F720440404000214672616D652E496E6E657242727573682E477261
            6469656E742E56697369626C65091B4672616D652E4D6964646C654272757368
            2E4261636B436F6C6F720708636C59656C6C6F77234672616D652E4D6964646C
            6542727573682E4772616469656E742E456E64436F6C6F720482828200234672
            616D652E4D6964646C6542727573682E4772616469656E742E4D6964436F6C6F
            720707636C5768697465254672616D652E4D6964646C6542727573682E477261
            6469656E742E5374617274436F6C6F720706636C47726179224672616D652E4D
            6964646C6542727573682E4772616469656E742E56697369626C65091A467261
            6D652E4F7574657242727573682E4261636B436F6C6F720707636C477265656E
            224672616D652E4F7574657242727573682E4772616469656E742E456E64436F
            6C6F720440404000224672616D652E4F7574657242727573682E477261646965
            6E742E4D6964436F6C6F720707636C5768697465244672616D652E4F75746572
            42727573682E4772616469656E742E5374617274436F6C6F720708636C53696C
            766572214672616D652E4F7574657242727573682E4772616469656E742E5669
            7369626C65090B4672616D652E57696474680204114772616469656E742E456E
            64436F6C6F7204B3080E00134772616469656E742E5374617274436F6C6F7204
            B3080E00194F74686572536C6963652E4C6567656E642E56697369626C650800
            0000}
          ChartElevation = 315
          SeriesData = <
            item
              DataType = dtDBData
              SortOrder = soNone
              TopN = 0
              XType = xtText
            end>
        end
        object BarCode1: TfrxBarCodeView
          AllowVectorExport = True
          Left = 291.023810000000000000
          Top = 75.590600000000000000
          Width = 65.000000000000000000
          Height = 18.897650000000000000
          BarType = bcCode_2_5_interleaved
          Frame.Typ = []
          Rotation = 0
          TestLine = False
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ColorBar = clBlack
        end
      end
    end
  end
  object qryCliente: TFDQuery
    Connection = conFastReportExport
    SQL.Strings = (
      'SELECT * FROM CLIENTE;')
    Left = 192
    Top = 8
  end
  object conFastReportExport: TFDConnection
    Params.Strings = (
      'Database=C:\FastReportExport\Samples\DB\FAST_REPORT_EXPORT.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'CharacterSet=WIN1252'
      'Server=127.0.0.1'
      'DriverID=FB')
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    Left = 128
    Top = 8
  end
  object dsCliente: TDataSource
    AutoEdit = False
    DataSet = qryCliente
    Left = 256
    Top = 8
  end
  object frxDataSet: TfrxDBDataset
    UserName = 'DataSetCliente'
    CloseDataSource = False
    DataSet = qryCliente
    BCDToCurrency = False
    Left = 312
    Top = 8
  end
end
