pageextension 50022 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(Item)
        {
            group("Custom Fields")
            {
                field("Rolled-up Material Cost"; "Rolled-up Material Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("BEO Item Type"; "BEO Item Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Production Unit of Measure"; "Production Unit of Measure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Tolerance(%)"; "Tolerance(%)")
                {
                    ApplicationArea = all;
                    ToolTip = 'For Exceed Qty Allow, while doing GRN';
                }
            }
            // Add changes to page layout here
        }

    }
}