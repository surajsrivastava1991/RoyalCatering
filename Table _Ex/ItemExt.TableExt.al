tableextension 50021 "Item Ext" extends Item
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Item Type"; Option)
        {
            OptionMembers = " ","Recipe Item","Menu Item","Fixed Asset","Maintenance Item";
            OptionCaption = ' ,Recipe Item,Menu Item,Fixed Asset,Maintenance Item';
            DataClassification = CustomerContent;
        }

        field(50001; "Production Unit of Measure"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".code where("Item No." = field("No."));
        }
        field(50002; "Tolerance(%)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Menu Type"; Option)
        {
            OptionMembers = " ","Breakfast","Lunch","Dinner","Midnight","Coffee Break","Others";
            OptionCaption = ' ,Breakfast,Lunch,Dinner,Midnight,Coffee Break,Others';
            DataClassification = CustomerContent;
        }
        field(50004; "Quote Mandatory"; Boolean)
        {
            Caption = 'Quote Mandatory';
            DataClassification = ToBeClassified;
        }
    }
}