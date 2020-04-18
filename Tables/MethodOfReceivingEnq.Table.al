table 50056 "Method Of Receiving Enq."
{
    DataClassification = ToBeClassified;
    LookupPageId = "Enquiry Rec. Methods";

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