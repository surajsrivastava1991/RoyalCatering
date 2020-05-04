table 50088 "Posted Narration"
{
    Caption = 'Posted Narration';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(2; "Transaction No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction No.';
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(4; "Narration"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Narration';
        }
        field(5; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(6; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type';
            OptionMembers = " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
        }
        field(7; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
    }

    keys
    {
        key(PK; "Entry No.", "Transaction No.", "Line No.")
        {
            Clustered = true;
        }
        key(SK1; "Transaction No.")
        { }
        key(SK2; "Document No.")
        { }

    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}