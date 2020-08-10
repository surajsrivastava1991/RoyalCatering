table 50101 "PDC Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(2; "PDC Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Created,Reversed;
            OptionCaption = 'Created,Reversed';
            Caption = 'PDC Status';
        }
        field(3; "Created Date"; Date)
        {
            DataClassification = CustomerContent;
            caption = 'Created Date';
        }
        field(4; "Check Maturity Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Check Maturity Date';
        }
        field(5; "Check Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Check Amount';
        }
        field(6; "Entry Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry Posted';
        }
        field(7; "Jouranl Type"; Option)
        {
            DataClassification = CustomerContent;

            OptionMembers = "Payment Journal","Cash Journal";
            OptionCaption = 'Payment Journal,Cash Journal';
            Caption = 'Journal Type';
        }
        field(8; "Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Template';
        }
        field(9; "Batch No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Batch No.';
        }
        field(10; "Customer No./Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No./Vendor No.';
        }
        field(11; "Customer/Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer/Vendor Name';
        }
        field(12; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(13; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.';
        }
        field(14; "Bank Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account Name';
        }

    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
}