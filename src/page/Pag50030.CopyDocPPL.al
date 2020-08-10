page 50030 "CopyDoc PPL"
{
    PageType = Card;
    ApplicationArea = all;
    UsageCategory = Administration;
    SourceTable = "Production Plan Header";
    Caption = 'Get Production Line';

    layout
    {
        area(Content)
        {
            group(general)
            {
                field("Project No."; "Project No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Kitchen Location"; "Kitchen Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                    Editable = false;
                }
            }
            group("Filter")
            {

                field(ProductionPlanHeaderG; ProductionPlanHeaderG)
                {
                    Caption = 'Production Plan No.';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    TableRelation = "Production Plan Header" where("Project No." = field("Project No."), "Kitchen Location" = field("Kitchen Location"));

                    trigger OnValidate()
                    var
                        ProductionPlanLineL: record "Production Plan Line";
                        CopyProductionPlanL: record "Copy Production Line";
                    begin

                        CopyProductionPlanL.Reset();
                        CopyProductionPlanL.DeleteAll();
                        ProductionPlanLineL.Reset();
                        ProductionPlanLineL.SetRange("Production Plan No.", ProductionPlanHeaderG);
                        if ProductionPlanLineL.FindSet() then
                            repeat
                                CopyProductionPlanL.Init();
                                CopyProductionPlanL.TransferFields(ProductionPlanLineL);
                                CopyProductionPlanL.validate("Recipe Cost", 0);
                                CopyProductionPlanL."Recipe Cost(Base)" := 0;
                                CopyProductionPlanL."Cal. Standard Cost Run Date" := 0D;
                                CopyProductionPlanL."Calculation Standard Cost" := false;

                                CopyProductionPlanL.Insert();
                            until ProductionPlanLineL.next() = 0;
                    end;

                }
            }


            part(Lines; "Copy Production Plan Subpage")
            {
                Caption = 'Production Plan Lines';
                ApplicationArea = all;
                ToolTip = 'Table field';
            }
        }
    }
    var
        ProductionPlanHeaderG: Code[20];

}