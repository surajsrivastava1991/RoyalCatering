table 50071 "Locationwise Purchaser"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Purchaser Code"; code[50])
        {
            Caption = 'Purchaser Code';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(2; "Location"; Code[10])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(3; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
    }

    keys
    {
        key(PK; "Purchaser Code")
        {
            Clustered = true;
        }
    }

}