page 50037 "Purchase Indent Subpage"
{

    PageType = ListPart;
    SourceTable = "Purchase Indent Line";
    Caption = 'Purchase Indent Subpage';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Receiving Location"; "Receiving Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table fields';
                }
                field("Requested Date"; "Requested Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
            }
        }
    }
}