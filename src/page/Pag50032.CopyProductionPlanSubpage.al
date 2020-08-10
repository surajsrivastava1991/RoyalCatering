page 50032 "Copy Production Plan Subpage"
{

    PageType = ListPart;
    SourceTable = "Copy Production Line";
    Caption = 'Production Plan Subpage';
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
                field(Description; Description)
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
                field("Recipe Cost"; "Recipe Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Recipe Cost(Base)"; "Recipe Cost(Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Calculation Standard Cost"; "Calculation Standard Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Cal. Standard Cost Run Date"; "Cal. Standard Cost Run Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Copy Production Line")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Table field';
                Caption = 'Copy Production Line';
                Image = CopyDocument;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(CopyProductionLineG);
                    DocumentNoG := SingleInstanceCodeG.GetValue();
                    if CopyProductionLineG.FindSet() then
                        repeat
                            ProductionLineG.Init();
                            ProductionLineG.TransferFields(CopyProductionLineG);
                            ProductionLineG."Production Plan No." := DocumentNoG;
                            ProductionLineG.Insert();
                        until CopyProductionLineG.next() = 0;

                    CopyProductionLineG.reset();
                    CopyProductionLineG.DeleteAll(true);

                    CurrPage.Close();



                end;
            }
        }
    }
    var
        CopyProductionLineG: Record "Copy Production Line";
        ProductionLineG: record "Production Plan Line";
        SingleInstanceCodeG: Codeunit "Single Instance";

        DocumentNoG: Code[20];

}