pageextension 50042 "Gen journal line" extends "General Journal"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("CL from Date"; "CL from Date")
            {
                ApplicationArea = all;
                ToolTip = 'Cost Allocation From Date';
            }
            field("CL To Date"; "CL To Date")
            {
                ApplicationArea = all;
                ToolTip = 'Cost Allocation To Date';
            }
            field("Bulk Kitchen"; "Bulk Kitchen")
            {
                ApplicationArea = all;
                ToolTip = 'Cost Allocation Bulk Allocation';
            }
            field("Voucher Name"; "Voucher Name")
            {
                ApplicationArea = all;
                ToolTip = 'Voucher Name for posted Voucher Report';
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        modify(Post)
        {
            Visible = DocEnable;
        }
        addafter("Test Report")
        {
            action(Post1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                Visible = DocEnable1;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    costallocationL: Record "Cost Allocation Header";
                    GLentryL: Record "G/L Entry";
                    ProductionPlanHeaderL: Record "Production Plan Header";
                    TD: Date;
                    FD: date;
                    LocationCodeL: Code[20];
                begin
                    TD := REC."CL To Date";
                    FD := REC."CL from Date";
                    LocationCodeL := rec."Bulk Kitchen";
                    GeneralLedgerSetup.get();
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", Rec);
                    CurrentJnlBatchName := GetRangeMax("Journal Batch Name");

                    if GeneralLedgerSetup."Post with Job Queue" then
                        NewDocumentNo();

                    GLentryL.Reset();
                    GLentryL.SetRange("CL from Date", FD);
                    GLentryL.SetRange("CL To Date", TD);
                    GLentryL.SetRange("Bulk Kitchen", LocationCodeL);
                    if GLentryL.FindFirst() then begin
                        costallocationL.Reset();
                        costallocationL.SetRange("from Date", FD);
                        costallocationL.SetRange("To Date", TD);
                        costallocationL.SetRange("Bulk Location", LocationCodeL);
                        if costallocationL.FindFirst() then begin
                            costallocationL."Voucher No. (Posted)" := GLentryL."Document No.";
                            costallocationL."Journal Posted" := true;
                            costallocationL.Modify(true);

                            //Suraj 18/05/20 Start
                            ProductionPlanHeaderL.Reset();
                            ProductionPlanHeaderL.SetRange("Kitchen Location", LocationCodeL);
                            ProductionPlanHeaderL.SetRange("Delivery Date", FD, TD);
                            ProductionPlanHeaderL.SetRange("Cost Posted", false);
                            if ProductionPlanHeaderL.FindSet() then
                                repeat
                                    ProductionPlanHeaderL."Cost Posted" := true;
                                    ProductionPlanHeaderL.Modify(true);
                                until ProductionPlanHeaderL.Next() = 0;
                            //Suraj 18/05/20 End
                        end;
                    end;
                end;
            }
        }
        addafter("&Line")
        {
            group("Export Excel")
            {

                action("Import Excel")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Excel';
                    Image = ImportExcel;
                    ToolTip = 'Import Excel for Payment Journal';

                    trigger OnAction()
                    begin
                        ImportGenJouLine();
                    end;
                }
            }
        }      // Add changes to page actions here\
    }

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrentJnlBatchName: Code[10];
        DocEnable: Boolean;
        DocEnable1: Boolean;

    trigger OnAfterGetRecord()
    begin

        if ("CL To Date" <> 0D) and ("CL To Date" <> 0D) and ("Bulk Kitchen" <> '')
        then begin
            DocEnable := false;
            DocEnable1 := true;
        end else begin
            DocEnable := true;
            DocEnable1 := false;
        end;
    end;

    trigger OnOpenPage()
    begin
        if ("CL To Date" <> 0D) and ("CL To Date" <> 0D) and ("Bulk Kitchen" <> '')
           then begin
            DocEnable := false;
            DocEnable1 := true;
        end else begin
            DocEnable := true;
            DocEnable1 := false;
        end;

    end;

    var
        ExcelBuffer: Record "Excel Buffer";

    procedure ImportGenJouLine()
    var
        GenJournalLineL: Record "Gen. Journal Line";


        TotalRow: Integer;
        RowNo: Integer;
        Filename: Text;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;
        LineNoG: Integer;
    begin

        GenJournalLineL.Reset();
        GenJournalLineL.SetRange("Journal Template Name", "Journal Template Name");
        GenJournalLineL.setrange("Journal Batch Name", "journal Batch Name");
        if GenJournalLineL.FindLast() then
            LineNoG := GenJournalLineL."Line No.";

        FileUploaded := UploadIntoStream('Select Timesheet to Upload', '', '', Filename, Instr);

        if Filename = '' then
            exit;

        ExcelBuffer.DeleteAll();
        ExcelBuffer.Reset();
        Sheetname := ExcelBuffer.SelectSheetsNameStream(Instr);
        ExcelBuffer.OpenBookStream(Instr, Sheetname);
        ExcelBuffer.ReadSheet();

        if ExcelBuffer.FindLast() then
            TotalRow := ExcelBuffer."Row No.";

        for RowNo := 2 to TotalRow do begin
            GenJournalLineL.Init();
            GenJournalLineL.VALIDATE("Journal Template Name", "Journal Template Name");
            GenJournalLineL.VALIDATE("Journal Batch Name", "journal Batch Name");
            GenJournalLineL."Line No." := LineNoG + 10000;
            Evaluate(GenJournalLineL."Posting Date", GetValueAtIndex(RowNo, 1));
            GenJournalLineL.Validate("Posting Date");
            Evaluate(GenJournalLineL."Document Date", GetValueAtIndex(RowNo, 2));
            Evaluate(GenJournalLineL."Document Type", GetValueAtIndex(RowNo, 3));
            Evaluate(GenJournalLineL."Document No.", GetValueAtIndex(RowNo, 4));
            Evaluate(GenJournalLineL."External Document No.", GetValueAtIndex(RowNo, 5));
            Evaluate(GenJournalLineL."Account Type", GetValueAtIndex(RowNo, 6));
            Evaluate(GenJournalLineL."Account No.", GetValueAtIndex(RowNo, 7));
            GenJournalLineL.validate("Account No.");
            Evaluate(GenJournalLineL."Currency Code", GetValueAtIndex(RowNo, 8));
            Evaluate(GenJournalLineL."Payment Method Code", GetValueAtIndex(RowNo, 9));
            Evaluate(GenJournalLineL."Debit Amount", GetValueAtIndex(RowNo, 10));
            GenJournalLineL.Validate("Debit Amount");
            Evaluate(GenJournalLineL."Credit Amount", GetValueAtIndex(RowNo, 11));
            GenJournalLineL.Validate("Debit Amount");
            Evaluate(GenJournalLineL."Bal. Account Type", GetValueAtIndex(RowNo, 12));
            Evaluate(GenJournalLineL."Bal. Account No.", GetValueAtIndex(RowNo, 13));
            GenJournalLineL.Validate("Bal. Account No.");
            Evaluate(GenJournalLineL."Shortcut Dimension 1 Code", GetValueAtIndex(RowNo, 14));
            if GenJournalLineL."Shortcut Dimension 1 Code" <> '' then
                GenJournalLineL.Validate("Shortcut Dimension 1 Code");
            Evaluate(GenJournalLineL."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 15));
            if GenJournalLineL."Shortcut Dimension 2 Code" <> '' then
                GenJournalLineL.Validate("Shortcut Dimension 2 Code");
            Evaluate(GenJournalLineL."VAT Bus. Posting Group", GetValueAtIndex(RowNo, 16));
            Evaluate(GenJournalLineL."VAT Prod. Posting Group", GetValueAtIndex(RowNo, 17));
            if GenJournalLineL.Insert(true) then;
            LineNoG += 10000;
        end;

        Message('%1 rows imported successfully !!!', TotalRow - 1);

    end;

    local procedure GetValueAtIndex(RowNoP: Integer; ColNoP: Integer): Text
    begin
        IF ExcelBuffer.Get(RowNoP, ColNoP) then
            exit(ExcelBuffer."Cell Value as Text");
    end;

}