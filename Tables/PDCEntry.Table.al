table 50101 "PDC Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(2; "PDC Status"; Option)
        {
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
    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
}