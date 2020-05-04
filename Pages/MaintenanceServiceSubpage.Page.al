page 50072 "Maintenance Service Subpage"
{
    PageType = ListPart;
    SourceTable = "Maintenance Service Line";
    Caption = 'Maintenance Service Subpage';
    AutoSplitKey = true;
    //DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(UOM; UOM)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Consumption Location"; "Consumption Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Consumption Date"; "Consumption Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Consumption Date';
                }
                field("Project Code"; "Project Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project Description"; "Project Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Item Ledger Entry"; "Item Ledger Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Item Ledger Entry Qty."; "Item Ledger Entry Qty.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Item Ledger Entry Quantity';
                }
                field("Cost Amount(Actual)"; "Cost Amount(Actual)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Actual Cost Amount';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Posting")
            {
                Caption = 'Posting';
                action("Neg. Adjustment Posting")
                {
                    ApplicationArea = all;
                    ToolTip = 'Negative Invetory of maintenance service Items';
                    Image = Copy;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        MaintenanceLineL: Record "Maintenance Service Line";
                        locationL: Record Location;
                        ItemLedgerEntryL: Record "Item Ledger Entry";
                        ItemJournalPostingL: Codeunit "General Ledger Posting";

                    begin
                        CurrPage.SetSelectionFilter(MaintenanceLineL);
                        if MaintenanceLineL.FindSet() then
                            ItemJournalPostingL.MaintenanceServiceItemToItemJournal(MaintenanceLineL);

                        if MaintenanceLineL.FindSet() then
                            repeat
                                ItemLedgerEntryL.Reset();
                                ItemLedgerEntryL.SetRange("Reference Document No.", MaintenanceLineL."MRO No.");
                                ItemLedgerEntryL.SetRange("Maintenance Line No.", MaintenanceLineL."Line No.");
                                if ItemLedgerEntryL.FindFirst() then begin
                                    MaintenanceLineL."Item Ledger Entry" := ItemLedgerEntryL."Entry No.";
                                    MaintenanceLineL."Item Ledger Entry Qty." := ItemLedgerEntryL.Quantity;
                                    MaintenanceLineL.Posted := true;
                                    MaintenanceLineL.Modify(true);

                                end;
                            until MaintenanceLineL.next() = 0;

                    end;
                }
            }
        }
    }
}