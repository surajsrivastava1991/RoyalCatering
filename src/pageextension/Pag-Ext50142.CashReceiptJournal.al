pageextension 50142 "Cash Receipt Journal" extends "Cash Receipt Journal"
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
        GenJournalBatchL: Record "Gen. Journal Batch";
        ExcelBuffer: Record "Excel Buffer";

        TotalRow: Integer;
        RowNo: Integer;
        Filename: Text;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;
        LineNoG: Integer;
        BatchName: Text[80];
    begin
        GenJournalBatchL.Reset();
        GenJournalBatchL.SetRange("Journal Template Name", "Journal Template Name");
        GenJournalBatchL.setrange("Name", "journal Batch Name");
        if GenJournalBatchL.Findfirst() then
            BatchName := GenJournalBatchL."Voucher Name";

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
            if GetValueAtIndex(RowNo, 10) = '' then
                GenJournalLineL."Debit Amount" := 0
            else
                Evaluate(GenJournalLineL."Debit Amount", GetValueAtIndex(RowNo, 10));
            GenJournalLineL.Validate("Debit Amount");
            if GetValueAtIndex(RowNo, 11) = '' then
                GenJournalLineL."Credit Amount" := 0
            else
                Evaluate(GenJournalLineL."Credit Amount", GetValueAtIndex(RowNo, 11));
            GenJournalLineL.Validate("Credit Amount");
            Evaluate(GenJournalLineL."Bal. Account Type", GetValueAtIndex(RowNo, 12));
            Evaluate(GenJournalLineL."Bal. Account No.", GetValueAtIndex(RowNo, 13));
            GenJournalLineL.Validate("Bal. Account No.");
            Evaluate(GenJournalLineL."Shortcut Dimension 1 Code", GetValueAtIndex(RowNo, 14));
            if GenJournalLineL."Shortcut Dimension 1 Code" <> '' then
                GenJournalLineL.Validate("Shortcut Dimension 1 Code");
            Evaluate(GenJournalLineL."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 15));
            if GenJournalLineL."Shortcut Dimension 2 Code" <> '' then
                GenJournalLineL.Validate("Shortcut Dimension 2 Code");
            Evaluate(GenJournalLineL."Gen. Posting Type", GetValueAtIndex(RowNo, 18));
            Evaluate(GenJournalLineL."VAT Bus. Posting Group", GetValueAtIndex(RowNo, 16));
            GenJournalLineL.Validate("VAT Bus. Posting Group");
            Evaluate(GenJournalLineL."VAT Prod. Posting Group", GetValueAtIndex(RowNo, 17));
            GenJournalLineL.Validate("VAT Prod. Posting Group");
            GenJournalLineL."Voucher Name" := BatchName;
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