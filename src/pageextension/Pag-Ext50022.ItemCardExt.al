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
                field("Item Type"; "Item Type")
                {
                    Caption = 'Item Type';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Production Unit of Measure"; "Production Unit of Measure")
                {
                    Caption = 'Production Plan/BOM UOM';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Tolerance(%)"; "Tolerance(%)")
                {
                    ApplicationArea = all;
                    ToolTip = 'For Exceed Qty Allow, while doing GRN';
                }
                field("Menu Type"; "Menu Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Menu Type for grouping in Production plan or report';
                }
                field("Quote Mandatory"; "Quote Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Quotation creation mandatory after requisition';
                }
            }
            // Add changes to page layout here
        }

    }
}