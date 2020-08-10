tableextension 50021 "Item Ext" extends Item
{
    DrillDownPageId = "Item Lookup";
    fields
    {
        modify("Base Unit of Measure")
        {
            trigger OnAfterValidate()
            var
                UOML: Record "Unit of Measure";
            begin
                if UOML.get("Base Unit of Measure") then
                    if UOML."Default Item Rounding" <> 0 then
                        "Rounding Precision" := UOML."Default Item Rounding";
            end;
        }
        // Add changes to table fields here
        field(50000; "Item Type"; Option)
        {
            OptionMembers = " ","Recipe Item","Menu Item","Fixed Asset","Maintenance Item";
            OptionCaption = ' ,Recipe Item,Menu Item,Fixed Asset,Maintenance Item';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Item Type" = "Item Type"::"Recipe Item" then
                    "Replenishment System" := "Replenishment System"::"Prod. Order"
                else
                    "Replenishment System" := "Replenishment System"::Purchase;
            end;
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
            DataClassification = CustomerContent;
            Caption = 'Quote Mandatory';
        }
    }
}