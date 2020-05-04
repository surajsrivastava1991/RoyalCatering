table 50087 "Narration"
{
    Caption = 'Narration';

    fields
    {
        field(1; "Journal Template Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Template Name';
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Batch Name';
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(4; "Gen. Journal Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Gen. Journal Line No.';
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(6; "Narration"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Narration';
        }

    }

    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Document No.", "Gen. Journal Line No.", "Line No.")
        {
            Clustered = true;
        }
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

    procedure CreateNarration(LineNoP: Integer; NarrationTextP: Text[50])
    var
        NarrationL: Record Narration;
    begin
        NarrationL.Reset();
        NarrationL."Journal Template Name" := "Journal Template Name";
        NarrationL."Journal Batch Name" := "Journal Batch Name";
        NarrationL."Gen. Journal Line No." := "Gen. Journal Line No.";
        NarrationL."Document No." := "Document No.";
        NarrationL."Line No." := LineNoP;
        NarrationL.Narration := NarrationTextP;
        NarrationL.Insert();
    End;
}