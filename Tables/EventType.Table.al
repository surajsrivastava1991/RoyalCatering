table 50054 "Event Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Event Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}