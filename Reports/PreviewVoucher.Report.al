Report 50081 "Preview Voucher"
{
    Caption = 'Preview Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './res/PreviewVoucher.rdl';

    dataset
    {
        dataitem("G/L Entry"; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Ext Document No.", "Ext Posting Date", "Ext Amount") order(descending);
            RequestFilterFields = "Posting Date", "Document No.";

            column(VoucherSourceDesc; SourceDesc)
            { }
            column(DocumentNo_GLEntry; "Document No.")
            { }
            column(PostingDateFormatted; 'Date: ' + Format("Posting Date"))
            { }
            column(CompanyInformationAddress; CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + '  ' + CompanyInformation.City)
            { }
            column(CompanyInformationName; CompanyInformation.Name)
            { }
            column(CreditAmount_GLEntry; "Credit Amount")
            { }
            column(DebitAmount_GLEntry; "Debit Amount")
            { }
            column(DrText; DrText)
            { }
            column(GLAccName; GLAccName)
            { }
            column(CrText; CrText)
            { }
            column(DebitAmountTotal; DebitAmountTotal)
            { }
            column(CreditAmountTotal; CreditAmountTotal)
            { }
            column(ChequeDetail; 'Cheque No: ' + ChequeNo + '  Dated: ' + Format(ChequeDate))
            { }
            column(ChequeNo; ChequeNo)
            { }
            column(ChequeDate; ChequeDate)
            { }
            column(RsNumberText1NumberText2; 'Rs. ' + NumberText[1] + ' ' + NumberText[2])
            { }
            column(EntryNo_GLEntry; "Line No.")
            { }
            column(PostingDate_GLEntry; "Posting Date")
            { }
            column(TransactionNo_GLEntry; "Document No.")
            { }
            column(VoucherNoCaption; VoucherNoCaptionLbl)
            { }
            column(CreditAmountCaption; CreditAmountCaptionLbl)
            { }
            column(DebitAmountCaption; DebitAmountCaptionLbl)
            { }
            column(ParticularsCaption; ParticularsCaptionLbl)
            { }
            column(AmountInWordsCaption; AmountInWordsCaptionLbl)
            { }
            column(PreparedByCaption; PreparedByCaptionLbl)
            { }
            column(CheckedByCaption; CheckedByCaptionLbl)
            { }
            column(ApprovedByCaption; ApprovedByCaptionLbl)
            { }
            dataitem(LineNarration; "Narration")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"),
                    "Journal Batch Name" = FIELD("Journal Batch Name"),
                    "Gen. Journal Line No." = FIELD("Line No."), "Document No." = FIELD("Document No.");
                //DataItemTableView = sorting ();

                column(Narration_LineNarration; Narration)
                { }
                column(PrintLineNarration; PrintLineNarration)
                { }
                trigger OnAfterGetRecord();
                begin
                    if PrintLineNarration then begin
                        PageLoop := PageLoop - 1;
                        LinesPrinted := LinesPrinted + 1;
                    end;
                end;

            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number);

                column(IntegerOccurcesCaption; IntegerOccurcesCaptionLbl)
                { }
                trigger OnAfterGetRecord();
                begin
                    PageLoop := PageLoop - 1;
                end;

                trigger OnPreDataItem();
                begin
                    GenJournalLine.Reset();
                    GenJournalLine.Reset();
                    GenJournalLine.SetCurrentKey("Ext Document No.", "Ext Posting Date", "Ext Amount");
                    GenJournalLine.Ascending(false);
                    GenJournalLine.SetRange("Journal Template Name", "G/L Entry"."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", "G/L Entry"."Journal Batch Name");
                    GenJournalLine.SetRange("Posting Date", "G/L Entry"."Posting Date");
                    GenJournalLine.SetRange("Document No.", "G/L Entry"."Document No.");
                    GenJournalLine.FindLast;
                    if not (GenJournalLine."Line No." = "G/L Entry"."Line No.") then
                        CurrReport.Break;
                    SetRange(Number, 1, PageLoop)
                end;

            }
            dataitem(PostedNarration1; "Narration")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"),
                    "Journal Batch Name" = FIELD("Journal Batch Name"),
                    "Document No." = FIELD("Document No.");
                DataItemTableView = where("Gen. Journal Line No." = Const(0));

                column(Narration_PostedNarration1; Narration)
                { }
                column(NarrationCaption; NarrationCaptionLbl)
                { }
                trigger OnPreDataItem();
                begin
                    //GLEntry.SetCurrentkey("Document No.", "Posting Date", Amount);
                    GenJournalLine.Reset();
                    GenJournalLine.SetCurrentKey("Ext Document No.", "Ext Posting Date", "Ext Amount");
                    GenJournalLine.Ascending(false);
                    GenJournalLine.SetRange("Journal Template Name", "G/L Entry"."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", "G/L Entry"."Journal Batch Name");
                    GenJournalLine.SetRange("Posting Date", "G/L Entry"."Posting Date");
                    GenJournalLine.SetRange("Document No.", "G/L Entry"."Document No.");
                    GenJournalLine.FindLast;
                    if not (GenJournalLine."Line No." = "G/L Entry"."Line No.") then
                        CurrReport.Break;
                end;

            }
            trigger OnAfterGetRecord();
            begin
                //  GLAccName := FindGLAccName("Source Type", "Line No.", "Source No.", "Account No.");
                if Amount < 0 then begin
                    CrText := 'To';
                    DrText := '';
                end else begin
                    CrText := '';
                    DrText := 'Dr';
                end;
                SourceDesc := '';
                /*  if "Source Code" <> '' then begin
                     SourceCode.Get("Source Code");
                     SourceDesc := SourceCode.Description;
                 end; */
                if "Journal Batch Name" <> '' then begin
                    GenJournalBatch.Reset();
                    GenJournalBatch.SetRange(Name, "Journal Batch Name");
                    GenJournalBatch.SetRange("Journal Template Name", "Journal Template Name");
                    if GenJournalBatch.FindFirst() then
                        SourceDesc := GenJournalBatch.Description;
                end else
                    SourceDesc := 'Payment Journal';
                PageLoop := PageLoop - 1;
                LinesPrinted := LinesPrinted + 1;
                ChequeNo := '';
                ChequeDate := 0D;
                /* if ("Source No." <> '') and ("Source Type" = "source type"::"Bank Account") then begin
                    if BankAccLedgEntry.Get("Entry No.") then begin
                        ChequeNo := BankAccLedgEntry."Document No.";
                        ChequeDate := BankAccLedgEntry."Document Date";
                    end;
                end; */
                if (ChequeNo <> '') and (ChequeDate <> 0D) then begin
                    PageLoop := PageLoop - 1;
                    LinesPrinted := LinesPrinted + 1;
                end;
                if PostingDate <> "Posting Date" then begin
                    PostingDate := "Posting Date";
                    TotalDebitAmt := 0;
                end;
                if DocumentNo <> "Document No." then begin
                    DocumentNo := "Document No.";
                    TotalDebitAmt := 0;
                end;
                if PostingDate = "Posting Date" then begin
                    InitTextVariable;
                    TotalDebitAmt += "Debit Amount";
                    FormatNoText(NumberText, Abs(TotalDebitAmt), '');
                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                end;
                if (PrePostingDate <> "Posting Date") or (PreDocumentNo <> "Document No.") then begin
                    DebitAmountTotal := 0;
                    CreditAmountTotal := 0;
                    PrePostingDate := "Posting Date";
                    PreDocumentNo := "Document No.";
                end;
                DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                CreditAmountTotal := CreditAmountTotal + "Credit Amount";
            end;

            trigger OnPreDataItem();
            begin
                NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;
                DebitAmountTotal := 0;
                CreditAmountTotal := 0;
            end;

        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintLineNarration; PrintLineNarration)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'PrintLineNarration';
                    }
                    /* field(ForNavOpenDesigner; ReportForNavOpenDesigner)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Design';
                        Visible = ReportForNavAllowDesign;
                    } */
                }
            }
        }

        actions
        {
        }
        trigger OnInit()
        begin
            PrintLineNarration := true;
        end;
    }

    trigger OnInitReport()
    begin
        PrintLineNarration := true;
        /* ;
        ReportForNav := ReportForNav.Report(CurrReport.ObjectId, CurrReport.Language, SerialNumber, UserId, COMPANYNAME);
        ReportForNav.Init; */
    end;


    trigger OnPostReport()
    begin
        //ReportForNav.Post;
    end;


    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        /* ;
        ReportForNav.OpenDesigner := ReportForNavOpenDesigner;
        if not ReportForNav.Pre then CurrReport.Quit; */
    end;

    var
        CompanyInformation: Record "Company Information";
        SourceCode: Record "Source Code";
        GenJournalBatch: Record "Gen. Journal Batch";
        //GLEntry: Record "G/L Entry";
        GenJournalLine: Record "Gen. Journal Line";
        // BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLAccName: Text[50];
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText: array[2] of Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[50];
        ChequeDate: Date;
        Text16526: label 'ZERO';
        Text16527: label 'HUNDRED';
        Text16528: label 'AND';
        Text16529: label '%1 results in a written number that is too long.';
        Text16532: label 'ONE';
        Text16533: label 'TWO';
        Text16534: label 'THREE';
        Text16535: label 'FOUR';
        Text16536: label 'FIVE';
        Text16537: label 'SIX';
        Text16538: label 'SEVEN';
        Text16539: label 'EIGHT';
        Text16540: label 'NINE';
        Text16541: label 'TEN';
        Text16542: label 'ELEVEN';
        Text16543: label 'TWELVE';
        Text16544: label 'THIRTEEN';
        Text16545: label 'FOURTEEN';
        Text16546: label 'FIFTEEN';
        Text16547: label 'SIXTEEN';
        Text16548: label 'SEVENTEEN';
        Text16549: label 'EIGHTEEN';
        Text16550: label 'NINETEEN';
        Text16551: label 'TWENTY';
        Text16552: label 'THIRTY';
        Text16553: label 'FORTY';
        Text16554: label 'FIFTY';
        Text16555: label 'SIXTY';
        Text16556: label 'SEVENTY';
        Text16557: label 'EIGHTY';
        Text16558: label 'NINETY';
        Text16559: label 'THOUSAND';
        Text16560: label 'MILLION';
        Text16561: label 'BILLION';
        Text16562: label 'LAKH';
        Text16563: label 'CRORE';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        PrintLineNarration: Boolean;
        PostingDate: Date;
        TotalDebitAmt: Decimal;
        DocumentNo: Code[20];
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrePostingDate: Date;
        PreDocumentNo: Code[50];
        VoucherNoCaptionLbl: label 'Voucher No. :';
        CreditAmountCaptionLbl: label 'Credit Amount';
        DebitAmountCaptionLbl: label 'Debit Amount';
        ParticularsCaptionLbl: label 'Particulars';
        AmountInWordsCaptionLbl: label 'Amount (in words):';
        PreparedByCaptionLbl: label 'Prepared by:';
        CheckedByCaptionLbl: label 'Checked by:';
        ApprovedByCaptionLbl: label 'Approved by:';
        IntegerOccurcesCaptionLbl: label 'IntegerOccurces';
        NarrationCaptionLbl: label 'Narration :';

    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50]
    var
        AccName: Text[50];
        //VendLedgerEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        //CustLedgerEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        //BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
        GLAccount: Record "G/L Account";
    begin
        if "Source Type" = "source type"::Vendor then begin
            Vend.Get("Source No.");
            AccName := Vend.Name;
        end else
            if "Source Type" = "source type"::Customer then begin
                Cust.Get("Source No.");
                AccName := Cust.Name;
            end else
                if "Source Type" = "source type"::"Bank Account" then begin
                    Bank.Get("Source No.");
                    AccName := Bank.Name;
                end else
                    if "Source Type" = "source type"::" " then begin
                        GLAccount.Get("G/L Account No.");
                        AccName := GLAccount.Name;
                    end;
        exit(AccName);
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';
        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                if No > 99999 then begin
                    Ones := No DIV (Power(100, Exponent - 1) * 10);
                    Hundreds := 0;
                end else begin
                    Ones := No DIV Power(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                end;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                if No > 99999 then
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(100, Exponent - 1) * 10
                else
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;
        if CurrencyCode <> '' then begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'AED');
        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);
        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526);
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ONLY')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ONLY');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;
        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text16529, AddText);
        end;
        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;
        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;
        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;


    // --> Reports ForNAV Autogenerated code - do not delete or modify
    /* var
         [WithEvents]
        ReportForNav: DotNet ForNavReport66868;
        [RunOnClient]
        ReportForNavClient: DotNet ForNavReport66868; 
        ReportForNavDialog: Dialog;
        ReportForNavOpenDesigner: Boolean;
        [InDataSet]
        ReportForNavAllowDesign: Boolean;

    trigger ReportForNav::OnInit();
    begin
        if ReportForNav.IsWindowsClient then begin
            ReportForNav.CheckClientAddIn();
            ReportForNavClient := ReportForNavClient.Report(ReportForNav.Definition);
            ReportForNavAllowDesign := ReportForNavClient.HasDesigner AND NOT ReportForNav.ParameterMode;
        end;
    end;

    trigger ReportForNav::OnSave(Base64Layout: Text);
    var
        CustomReportLayout: Record "Custom Report Layout";
        ReportLayoutSelection: Record "Report Layout Selection";
        LayoutId: Variant;
        TempBlob: Record TempBlob;
        OutStream: OutStream;
        Bstr: BigText;
        EmptyLayout: Text;
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        EmptyLayout := FORMAT(ReportLayoutSelection."Custom Report Layout Code");
        LayoutId := ReportLayoutSelection."Custom Report Layout Code";
        if ReportLayoutSelection.HasCustomLayout(ReportForNav.ReportID) = 1 then begin
            if FORMAT(ReportLayoutSelection.GetTempLayoutSelected) <> EmptyLayout then begin
                LayoutId := ReportLayoutSelection.GetTempLayoutSelected;
            end else begin
                if ReportLayoutSelection.GET(ReportForNav.ReportID, COMPANYNAME) then begin
                    LayoutId := ReportLayoutSelection."Custom Report Layout Code";
                end;
            end;
        end else begin
            if CONFIRM('Default custom layout not found. Create one?') then;
        end;
        if FORMAT(LayoutId) <> EmptyLayout then begin
            TempBlob.Blob.CREATEOUTSTREAM(OutStream);
            Bstr.ADDTEXT(Base64Layout);
            Bstr.WRITE(OutStream);
            CustomReportLayout.GET(LayoutId);
            CustomReportLayout.ImportLayoutBlob(TempBlob, 'RDL');
        end;
    end;

    trigger ReportForNav::OnParameters(Parameters: Text);
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        ReportForNav.Parameters := REPORT.RUNREQUESTPAGE(ReportForNav.ReportID, Parameters);
    end;

    trigger ReportForNav::OnPreview(Parameters: Text; FileName: Text);
    var
        PdfFile: File;
        InStream: InStream;
        OutStream: OutStream;
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        COMMIT;
        PdfFile.CREATETEMPFILE;
        PdfFile.CREATEOUTSTREAM(OutStream);
        REPORT.SAVEAS(ReportForNav.ReportID, Parameters, REPORTFORMAT::Pdf, OutStream);
        PdfFile.CREATEINSTREAM(InStream);
        ReportForNavClient.ShowDesigner;
        if ReportForNav.IsValidPdf(PdfFile.NAME) then DOWNLOADFROMSTREAM(InStream, '', '', '', FileName);
        PdfFile.CLOSE;
    end;

    trigger ReportForNav::OnSelectPrinter();
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        ReportForNav.PrinterSettings.PageSettings := ReportForNavClient.SelectPrinter(ReportForNav.PrinterSettings.PrinterName, ReportForNav.PrinterSettings.ShowPrinterDialog, ReportForNav.PrinterSettings.PageSettings);
    end;

    trigger ReportForNav::OnPrint(InStream: DotNet SystemIOStream66868);
    var
        ClientFileName: Text[255];
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        DOWNLOADFROMSTREAM(InStream, '', '<TEMP>', '', ClientFileName);
        ReportForNavClient.Print(ClientFileName);
    end;

    trigger ReportForNav::OnDesign(Data: Text);
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        ReportForNavClient.Data := Data;
        while ReportForNavClient.DesignReport do begin
            ReportForNav.HandleRequest(ReportForNavClient.GetRequest());
            SLEEP(100);
        end;
    end;

    trigger ReportForNav::OnView(ClientFileName: Text; Parameters: Text; ServerFileName: Text);
    var
        ServerFile: File;
        ServerInStream: InStream;
        "Filter": Text;
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        ServerFile.OPEN(ServerFileName);
        ServerFile.CREATEINSTREAM(ServerInStream);
        if STRLEN(ClientFileName) >= 4 then if LOWERCASE(COPYSTR(ClientFileName, STRLEN(ClientFileName) - 3, 4)) = '.pdf' then Filter := 'PDF (*.pdf)|*.pdf';
        if STRLEN(ClientFileName) >= 4 then if LOWERCASE(COPYSTR(ClientFileName, STRLEN(ClientFileName) - 3, 4)) = '.doc' then Filter := 'Microsoft Word (*.doc)|*.doc';
        if STRLEN(ClientFileName) >= 5 then if LOWERCASE(COPYSTR(ClientFileName, STRLEN(ClientFileName) - 4, 5)) = '.xlsx' then Filter := 'Microsoft Excel (*.xlsx)|*.xlsx';
        DOWNLOADFROMSTREAM(ServerInStream, 'Export', '', Filter, ClientFileName);
    end;

    trigger ReportForNav::OnMessage(Operation: Text; Parameter: Text; ParameterNo: Integer);
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        case Operation of
            'Open':
                ReportForNavDialog.Open(Parameter);
            'Update':
                ReportForNavDialog.Update(ParameterNo, Parameter);
            'Close':
                ReportForNavDialog.Close();
            'Message':
                Message(Parameter);
            'Error':
                Error(Parameter);
        end;
    end;

    trigger ReportForNav::OnPrintPreview(InStream: DotNet SystemIOStream66868; Preview: Boolean);
    var
        ClientFileName: Text[255];
    begin
        // This code is created automatically every time Reports ForNAV saves the report.
        // Do not modify this code.
        CurrReport.Language := System.GlobalLanguage;
        DownloadFromStream(InStream, '', '<TEMP>', '', ClientFileName);
        ReportForNavClient.PrintPreviewDialog(ClientFileName, ReportForNav.PrinterSettings.PrinterName, Preview);
    end;

    trigger ReportForNav::OnGetWordLayout(reportNo: Integer)
    var
        layoutStream: InStream;
        zip: Codeunit "Zip Stream Wrapper";
        oStream: OutStream;
        iStream: InStream;
        layout: Text;
        dataContract: Text;
        tempBlob: Record "TempBlob";
        ReportLayoutSelection: Record "Report Layout Selection";
        CustomReportLayout: Record "Custom Report Layout";
        CustomLayoutID: Variant;
        EmptyLayout: Text;
        props: XmlDocument;
        prop: XmlNode;
        layoutNode: XmlNode;
    begin
        EmptyLayout := FORMAT(ReportLayoutSelection."Custom Report Layout Code");
        CustomLayoutID := ReportLayoutSelection."Custom Report Layout Code";
        if Format(ReportLayoutSelection.GetTempLayoutSelected) <> EmptyLayout then
            CustomLayoutID := ReportLayoutSelection.GetTempLayoutSelected
        else
            if ReportLayoutSelection.HasCustomLayout(reportNo) = 2 then
                CustomLayoutID := ReportLayoutSelection."Custom Report Layout Code";

        if (Format(CustomLayoutID) <> EmptyLayout) AND CustomReportLayout.GET(CustomLayoutID) then begin
            CustomReportLayout.TestField(Type, CustomReportLayout.Type::Word);
            CustomReportLayout.CalcFields(Layout);
            CustomReportLayout.Layout.CreateInstream(layoutStream, TEXTENCODING::UTF8);
        end else
            Report.WordLayout(reportNo, layoutStream);
        zip.OpenZipFromStream(layoutStream, false);
        tempBlob.Blob.CreateOutStream(oStream);
        zip.WriteEntryFromZipToOutStream('docProps/custom.xml', oStream);
        tempBlob.Blob.CreateInStream(iStream);
        XmlDocument.ReadFrom(iStream, props);
        props.GetChildNodes().Get(1, prop);
        prop.AsXmlElement().GetChildNodes().Get(1, layoutNode);
        layout := layoutNode.AsXmlElement().InnerText();
        ReportForNav.WordLayout := layout;
    end;
    procedure ReportForNav_GetPageNo(): Integer
    begin
        exit(ReportForNav.PageNo);
    end;
 */
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
