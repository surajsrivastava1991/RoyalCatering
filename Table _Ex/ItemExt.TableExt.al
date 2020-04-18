tableextension 50021 "Item Ext" extends Item
{
    fields
    {
        // Add changes to table fields here
        field(50000; "BEO Item Type"; Option)
        {
            OptionMembers = " ","Recipe Item","Menu Item";
            OptionCaption = ' ,Recipe Item,Menu Item';
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
    }
}