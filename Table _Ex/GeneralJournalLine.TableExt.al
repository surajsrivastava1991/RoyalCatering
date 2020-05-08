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
        // field(50005; "Invoice Date"; Date)
        // {
        //     DataClassification = CustomerContent;
        //     Caption='Invoice Date';
        //     trigger OnValidate()
        //     var
        //         PaymentTerms: Record "Payment Terms";
        //     begin
        //         "Due Date" := 0D;
        //         IF ("Account Type" <> "Account Type"::"G/L Account") OR
        //            ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
        //         THEN
        //             CASE "Document Type" OF
        //                 "Document Type"::Invoice:
        //                     IF ("Payment Terms Code" <> '') AND ("Invoice Date" <> 0D) THEN BEGIN
        //                         PaymentTerms.GET("Payment Terms Code");
        //                         "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Invoice Date");
        //                     END;
        //                 "Document Type"::"Credit Memo":
        //                     IF ("Payment Terms Code" <> '') AND ("Invoice Date" <> 0D) THEN BEGIN
        //                         PaymentTerms.GET("Payment Terms Code");
        //                         IF PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
        //                             "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Invoice Date");
        //                         END ELSE
        //                             "Due Date" := "Invoice Date";
        //                     END;
        //                 ELSE
        //                     "Due Date" := "Invoice Date";
        //             END;

        //     end;
        // }
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
        field(50009; "Batch Description"; Text[80])
        {
            DataClassification = CustomerContent;
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
}