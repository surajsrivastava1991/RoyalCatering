tableextension 50041 "General Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "CL from Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "CL To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Bulk Kitchen"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Narration"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Narration';
            trigger OnValidate()
            var
                NarrationL: Record Narration;
                LineNoL: Integer;
                NarrationTextL: Text;
                i: Integer;
            begin
                NarrationL.Reset();
                NarrationL.SetRange("Journal Template Name", "Journal Template Name");
                NarrationL.SetRange("Journal Batch Name", "Journal Batch Name");
                NarrationL.SetRange("Gen. Journal Line No.", "Line No.");
                NarrationL.SetRange("Document No.", "Document No.");
                NarrationL.DeleteAll();

                NarrationTextL := Narration;
                for i := 1 to 5 do begin
                    LineNoL += 10000;
                    CreateLineNarration(LineNoL, CopyStr(NarrationTextL, 1, 50));
                    NarrationTextL := DelStr(NarrationTextL, 1, 50);
                    if NarrationTextL = '' then
                        i := 5;
                end;
            end;
        }
        field(50004; "Employee Dim"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Dim';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), "Blocked" = CONST(false));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Employee Dim");
            end;
        }
        field(50005; "Ext Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50006; "Ext Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Ext Amount"; Decimal)
        { DataClassification = CustomerContent; }

        field(50008; "Voucher Narration"; Text[250])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                NarrationL: Record Narration;
                LineNoL: Integer;
                NarrationTextL: Text;
                i: Integer;
            begin
                NarrationL.Reset();
                NarrationL.SetRange("Journal Template Name", "Journal Template Name");
                NarrationL.SetRange("Journal Batch Name", "Journal Batch Name");
                NarrationL.SetRange("Gen. Journal Line No.", 0);
                NarrationL.SetRange("Document No.", "Document No.");
                NarrationL.DeleteAll();

                NarrationTextL := "Voucher Narration";
                for i := 1 to 5 do begin
                    LineNoL += 10000;
                    CreateVoucherNarration(LineNoL, CopyStr(NarrationTextL, 1, 50));
                    NarrationTextL := DelStr(NarrationTextL, 1, 50);
                    if NarrationTextL = '' then
                        i := 5;
                end;
            end;
        }
        field(50009; "Voucher Name"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Voucher Name';
        }
        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                "Ext Document No." := "Document No.";
            end;
        }
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                "Ext Posting Date" := "Posting Date";
            end;
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                "Ext Amount" := Amount;
            end;
        }
    }


    keys
    {
        key(SK1; "Ext Document No.", "Ext Posting Date", "Ext Amount")
        { }
    }

    trigger OnAfterDelete()
    var
        NarrationL: Record Narration;
    begin
        NarrationL.Reset();
        NarrationL.SetRange("Journal Batch Name", "Journal Batch Name");
        NarrationL.SetRange("Journal Template Name", "Journal Template Name");
        NarrationL.SetRange("Document No.", "Document No.");
        NarrationL.SetRange("Gen. Journal Line No.", "Line No.");
        NarrationL.DeleteAll();
    end;

    procedure CreateLineNarration(LineNoP: Integer; NarrationTextP: Text[50])
    var
        NarrationL: Record Narration;
    begin
        NarrationL.Reset();
        NarrationL."Journal Template Name" := "Journal Template Name";
        NarrationL."Journal Batch Name" := "Journal Batch Name";
        NarrationL."Gen. Journal Line No." := "Line No.";
        NarrationL."Document No." := "Document No.";
        NarrationL."Line No." := LineNoP;
        NarrationL.Narration := NarrationTextP;
        NarrationL.Insert();
    End;

    procedure CreateVoucherNarration(LineNoP: Integer; NarrationTextP: Text[50])
    var
        NarrationL: Record Narration;
    begin
        NarrationL.Reset();
        NarrationL."Journal Template Name" := "Journal Template Name";
        NarrationL."Journal Batch Name" := "Journal Batch Name";
        NarrationL."Gen. Journal Line No." := 0;
        NarrationL."Document No." := "Document No.";
        NarrationL."Line No." := LineNoP;
        NarrationL.Narration := NarrationTextP;
        NarrationL.Insert();
    End;

    procedure CreatePDCPayable()
    var
        GenJournalLineL: Record "Gen. Journal Line";
        GLSetupL: Record "General Ledger Setup";
        GenjournalbatchL: Record "Gen. Journal Batch";
        PDCEntry: record "PDC Entry";
        NoSeriesManagementG: Codeunit NoSeriesManagement;
        DocumentNoL: Code[20];
        LineNoG: Integer;

    begin
        if PDCEntry.Get("Document No.") then
            Error('PDC Voucher generated already');

        LineNoG := 0;
        GLSetupL.Get();
        GLSetupL.TestField("PDC Template Name");
        GLSetupL.TestField("PDC Batch Name");
        GLSetupL.TestField("PDC Payable");
        TestField("Debit Amount");

        if "Document Date" > WorkDate() then
            Error('Document date should not be greater than Workdate');

        GenJournalLineL.Reset();
        GenJournalLineL.SetRange("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.setrange("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL.DeleteAll();

        GenjournalbatchL.Get(GLSetupL."PDC Template Name", GLSetupL."PDC Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(GenjournalbatchL."No. Series", "Posting Date", true);

        //Header Creation
        GenJournalLineL.Init();
        GenJournalLineL.VALIDATE("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.VALIDATE("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL."Line No." := LineNoG + 10000;
        GenJournalLineL.Validate("Document No.", DocumentNoL);
        GenJournalLineL."Posting Date" := "Document Date";
        GenJournalLineL."Account Type" := GenJournalLineL."Account Type"::Vendor;
        GenJournalLineL.VALIDATE("Account No.", "Account No.");
        GenJournalLineL.VALIDATE("Debit Amount", "Debit Amount");
        GenJournalLineL."Bal. Account Type" := GenJournalLineL."Bal. Account Type"::"G/L Account";
        GenJournalLineL.validate("Bal. Account No.", GLSetupL."PDC Payable");
        GenJournalLineL."CL from Date" := 0D;
        GenJournalLineL."CL To Date" := 0D;
        GenJournalLineL."Bulk Kitchen" := '';
        GenJournalLineL."Posting No. Series" := GenjournalbatchL."Posting No. Series";
        GenJournalLineL.validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
        if GenJournalLineL.Insert(true) then
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJournalLineL);

        PDCEntry.Init();
        PDCEntry."Document No." := "Document No.";
        PDCEntry."Created Date" := "Document Date";
        PDCEntry."Check Maturity Date" := "Posting Date";
        PDCEntry."PDC Status" := PDCEntry."PDC Status"::Created;
        PDCEntry.Insert();


        LineNoG += 10000;

    end;

    procedure ReservePDCPayable()
    var
        GenJournalLineL: Record "Gen. Journal Line";
        GLSetupL: Record "General Ledger Setup";
        GenjournalbatchL: Record "Gen. Journal Batch";
        PDCEntry: record "PDC Entry";
        NoSeriesManagementG: Codeunit NoSeriesManagement;
        DocumentNoL: Code[20];
        LineNoG: Integer;
    begin
        if PDCEntry.Get("Document No.") then begin
            if PDCEntry."PDC Status" = PDCEntry."PDC Status"::Reversed then
                Error('PDC Voucher reversed already');
        end else
            Error('PDC is not yet Generated');

        if "Posting Date" < WorkDate() then
            error('Posting date should not be less than the workdate');

        LineNoG := 0;
        GLSetupL.Get();
        GLSetupL.TestField("PDC Template Name");
        GLSetupL.TestField("PDC Batch Name");
        GLSetupL.TestField("PDC Payable");
        GenJournalLineL.Reset();
        GenJournalLineL.SetRange("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.setrange("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL.DeleteAll();

        GenjournalbatchL.Get(GLSetupL."PDC Template Name", GLSetupL."PDC Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(GenjournalbatchL."No. Series", "Posting Date", true);

        //Header Creation
        GenJournalLineL.Init();
        GenJournalLineL.VALIDATE("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.VALIDATE("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL."Line No." := LineNoG + 10000;
        GenJournalLineL.Validate("Document No.", DocumentNoL);
        GenJournalLineL."Posting Date" := "Posting Date";
        GenJournalLineL."Account Type" := GenJournalLineL."Account Type"::"G/L Account";
        GenJournalLineL.VALIDATE("Account No.", GLSetupL."PDC Payable");
        GenJournalLineL.VALIDATE("Debit Amount", "Debit Amount");
        GenJournalLineL."Bal. Account Type" := GenJournalLineL."Bal. Account Type"::Vendor;
        GenJournalLineL.validate("Bal. Account No.", "Account No.");
        GenJournalLineL."CL from Date" := 0D;
        GenJournalLineL."CL To Date" := 0D;
        GenJournalLineL."Bulk Kitchen" := '';
        GenJournalLineL."Posting No. Series" := GenjournalbatchL."Posting No. Series";
        GenJournalLineL.validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");

        if GenJournalLineL.Insert(true) then
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJournalLineL);
        PDCEntry.get("Document No.");
        PDCEntry."PDC Status" := PDCEntry."PDC Status"::Reversed;
        PDCEntry.Modify(true);

        LineNoG += 10000;
    end;

    procedure CreatePDCReceivable()
    var
        GenJournalLineL: Record "Gen. Journal Line";
        GLSetupL: Record "General Ledger Setup";
        GenjournalbatchL: Record "Gen. Journal Batch";
        PDCEntry: Record "PDC Entry";
        NoSeriesManagementG: Codeunit NoSeriesManagement;
        DocumentNoL: Code[20];
        LineNoG: Integer;

    begin
        if PDCEntry.Get("Document No.") then
            Error('PDC Voucher generated already');

        if "Document Date" > WorkDate() then
            Error('Document date should not be greater than Workdate');

        LineNoG := 0;
        GLSetupL.Get();
        GLSetupL.TestField("PDC Template Name");
        GLSetupL.TestField("PDC Batch Name");
        GLSetupL.TestField("PDC Payable");

        TestField("Credit Amount");

        GenJournalLineL.Reset();
        GenJournalLineL.SetRange("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.setrange("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL.DeleteAll();

        GenjournalbatchL.Get(GLSetupL."PDC Template Name", GLSetupL."PDC Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(GenjournalbatchL."No. Series", "Posting Date", true);

        //Header Creation
        GenJournalLineL.Init();
        GenJournalLineL.VALIDATE("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.VALIDATE("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL."Line No." := LineNoG + 10000;
        GenJournalLineL.Validate("Document No.", DocumentNoL);
        GenJournalLineL."Posting Date" := "Document Date";
        GenJournalLineL."Account Type" := GenJournalLineL."Account Type"::Customer;
        GenJournalLineL.VALIDATE("Account No.", "Account No.");
        GenJournalLineL.VALIDATE("Credit Amount", "Credit Amount");
        GenJournalLineL."Bal. Account Type" := GenJournalLineL."Bal. Account Type"::"G/L Account";
        GenJournalLineL.validate("Bal. Account No.", GLSetupL."PDC Receivable");
        GenJournalLineL."CL from Date" := 0D;
        GenJournalLineL."CL To Date" := 0D;
        GenJournalLineL."Bulk Kitchen" := '';
        GenJournalLineL."Posting No. Series" := GenjournalbatchL."Posting No. Series";
        GenJournalLineL.validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");

        if GenJournalLineL.Insert(true) then
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJournalLineL);
        PDCEntry.Init();
        PDCEntry."Document No." := "Payment Reference";
        PDCEntry."Created Date" := "Document Date";
        PDCEntry."Check Maturity Date" := "Posting Date";
        PDCEntry."PDC Status" := PDCEntry."PDC Status"::Created;
        PDCEntry.Insert();

        LineNoG += 10000;

    end;

    procedure ReservePDCReceivable()
    var
        GenJournalLineL: Record "Gen. Journal Line";
        GLSetupL: Record "General Ledger Setup";
        GenjournalbatchL: Record "Gen. Journal Batch";
        PDCEntry: Record "PDC Entry";
        NoSeriesManagementG: Codeunit NoSeriesManagement;
        DocumentNoL: Code[20];
        LineNoG: Integer;
    begin
        if PDCEntry.Get("Document No.") then begin
            if PDCEntry."PDC Status" = PDCEntry."PDC Status"::Reversed then
                Error('PDC Voucher reversed already');
        end else
            Error('PDC is not yet Generated');

        LineNoG := 0;
        GLSetupL.Get();
        GLSetupL.TestField("PDC Template Name");
        GLSetupL.TestField("PDC Batch Name");
        GLSetupL.TestField("PDC Payable");
        GenJournalLineL.Reset();
        GenJournalLineL.SetRange("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.setrange("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL.DeleteAll();

        GenjournalbatchL.Get(GLSetupL."PDC Template Name", GLSetupL."PDC Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(GenjournalbatchL."No. Series", "Posting Date", true);

        //Header Creation
        GenJournalLineL.Init();
        GenJournalLineL.VALIDATE("Journal Template Name", GLSetupL."PDC Template Name");
        GenJournalLineL.VALIDATE("Journal Batch Name", GLSetupL."PDC Batch Name");
        GenJournalLineL."Line No." := LineNoG + 10000;
        GenJournalLineL.Validate("Document No.", DocumentNoL);
        GenJournalLineL."Posting Date" := "Posting Date";
        GenJournalLineL."Account Type" := GenJournalLineL."Account Type"::"G/L Account";
        GenJournalLineL.VALIDATE("Account No.", GLSetupL."PDC Receivable");
        GenJournalLineL.VALIDATE("Credit Amount", "Credit Amount");
        GenJournalLineL."Bal. Account Type" := GenJournalLineL."Bal. Account Type"::Customer;
        GenJournalLineL.validate("Bal. Account No.", "Account No.");
        GenJournalLineL."CL from Date" := 0D;
        GenJournalLineL."CL To Date" := 0D;
        GenJournalLineL."Bulk Kitchen" := '';
        GenJournalLineL."Posting No. Series" := GenjournalbatchL."Posting No. Series";
        GenJournalLineL.validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
        if GenJournalLineL.Insert(true) then
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJournalLineL);
        PDCEntry.get("Document No.");
        PDCEntry."PDC Status" := PDCEntry."PDC Status"::Reversed;
        PDCEntry.Modify(true);

        LineNoG += 10000;
    end;
}