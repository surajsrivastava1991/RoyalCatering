page 50016 "Cost Allocation Card"
{
    PageType = Card;
    ApplicationArea = all;
    UsageCategory = Administration;
    SourceTable = "Cost Allocation Header";
    Caption = 'Cost Allocation Card';

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("From Date"; "From Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("To Date"; "To Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Bulk Location"; "Bulk Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Bulk Location Name"; "Bulk Location Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Bulk Allocation Cost"; "Bulk Allocation Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Journal Created"; "Journal Created")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Voucher No.(Pre)"; "Voucher No.(Pre)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Journal Posted"; "Journal Posted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Voucher No. (Posted)"; "Voucher No. (Posted)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Adjust Cost Item Entry"; "Adjust Cost Item Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Standard Cost Calculation"; "Standard Cost Calculation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Bulk Cost Allocation"; "Bulk Cost Allocation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Projec Cost Allocation"; "Project Cost Allocation")
                {
                    Caption = 'Project Cost Allocation';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }


            part(Lines; "Cost Allocation Subpage")
            {
                Caption = 'Production Planning Lines';
                ApplicationArea = all;
                ToolTip = 'Table field';
                SubPageLink = "From Date" = field("From Date"), "To Date" = field("To Date"), "Bulk Location" = field("Bulk Location");

            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Adjust Cost-Item Entries")
            {
                action("Adjust Cost-Item Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Image = AdjustItemCost;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        TestField("Bulk Location");
                        TestField("From Date");
                        TestField("To Date");
                        Report.Run(795);
                        "Adjust Cost Item Entry" := true;
                        "Standard Cost Calculation" := false;
                        "Bulk Cost Allocation" := false;
                        "Project Cost Allocation" := false;
                        if Modify() then
                            Message('Cost Adjustment done');
                    end;
                }
            }
            group("Recipe Cost Calculation")
            {
                Caption = 'Recipe Cost Calculation';
                action("Std. Cost Calculation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Image = CostAccounting;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        ProductionLineL: Record "Production Plan Line";
                        ItemL: Record Item;
                        CalculateStdCost: Codeunit "Standard Calculate  Cost";

                    begin
                        if not "Adjust Cost Item Entry" then
                            error('Run "Adjust Cost- Item Entries" first!');

                        ProductionPlanHeaderG.Reset();
                        ProductionPlanHeaderG.SetRange("Kitchen Location", "Bulk Location");
                        ProductionPlanHeaderG.SetRange("Delivery Date", "From Date", "To Date");
                        if ProductionPlanHeaderG.FindSet() then
                            repeat
                                ProductionLineL.Reset();
                                ProductionLineL.SetRange("Production Plan No.", ProductionPlanHeaderG."Production Plan No.");
                                if ProductionLineL.FindSet() then
                                    repeat
                                        ItemL.Get(ProductionLineL."Item No.");
                                        CalculateStdCost.CalcItem(ProductionLineL."Item No.", false);   //Standard Cost calculation
                                                                                                        // ItemL.CalcFields("Rolled-up Material Cost");
                                        ProductionLineL.validate("Recipe Cost(Base)", ItemL."Rolled-up Material Cost");
                                        ProductionLineL."Calculation Standard Cost" := true;
                                        ProductionLineL."Cal. Standard Cost Run Date" := Today();
                                        ProductionLineL.Modify();

                                    until ProductionLineL.next() = 0;
                            until ProductionPlanHeaderG.Next() = 0;

                        "Standard Cost Calculation" := true;
                        "Bulk Cost Allocation" := false;
                        "Project Cost Allocation" := false;
                        if Modify() then
                            Message('Recipe Cost Calculated');
                    end;
                }
            }
            group("Cost Allocation")
            {
                Caption = 'Cost Allocation';
                action(" Calculate Bulk Cost Allocation")
                {
                    Caption = 'Calculate Bulk Cost Allocation';
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Image = Allocations;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        GLEntryL: record "G/L Entry";
                        InventorySetupL: Record "Inventory Setup";
                    begin
                        if not "Standard Cost Calculation" then
                            error('Run "Standard Cost Calculation" first!');

                        "Bulk Allocation Cost" := 0;
                        InventorySetupL.Get();
                        GLEntryL.Reset();
                        GLEntryL.SetRange("G/L Account No.", InventorySetupL."Kitchen Cost Account");
                        GLEntryL.SetRange("Posting Date", "From Date", "To Date");
                        if GLEntryL.FindSet() then
                            repeat
                                "Bulk Allocation Cost" += GLEntryL.Amount;
                            until GLEntryL.Next() = 0;
                        "Bulk Cost Allocation" := true;
                        "Project Cost Allocation" := false;
                        if Modify() then
                            Message('Bulk cost calculated');

                    end;
                }
            }
            group("Project Cost Allocation")
            {
                Caption = 'Project Cost Allocation';
                action(" Create Project Cost Allocation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Image = Allocations;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        ProductionPlanHeaderL: record "Production Plan Header";
                        DimentionValueL: Record "Dimension Value";
                        CostAllocationLineL: record "Cost Allocation Line";
                    begin
                        if not "Bulk Cost Allocation" then
                            error('Run "Bulk Cost Allocation" first!');
                        TestField("Bulk Location");
                        LineNoG := 0;
                        CostAllocationLineL.Reset();
                        CostAllocationLineL.setrange("From Date", "From Date");
                        CostAllocationLineL.setrange("To Date", "To Date");
                        CostAllocationLineL.setrange("Bulk Location", "Bulk Location");
                        CostAllocationLineL.DeleteAll();

                        DimentionValueL.Reset();
                        if DimentionValueL.FindSet() then
                            repeat
                                ProductionPlanHeaderL.Reset();

                                ProductionPlanHeaderL.SetRange("Kitchen Location", "Bulk Location");
                                ProductionPlanHeaderL.SetRange("Delivery Date", "From Date", "To Date");
                                ProductionPlanHeaderL.SetRange("Project No.", DimentionValueL."code");
                                if ProductionPlanHeaderL.FindSet() then
                                    repeat
                                        CostAllocationLineL.Reset();
                                        CostAllocationLineL.setrange("From Date", "From Date");
                                        CostAllocationLineL.setrange("To Date", "To Date");
                                        CostAllocationLineL.setrange("Bulk Location", "Bulk Location");
                                        CostAllocationLineL.setrange("Project No.", DimentionValueL."code");
                                        if CostAllocationLineL.IsEmpty() then begin
                                            CostAllocationLineL.Init();
                                            CostAllocationLineL."From Date" := "From Date";
                                            CostAllocationLineL."To Date" := "To Date";
                                            CostAllocationLineL."Bulk Location" := "Bulk Location";
                                            CostAllocationLineL."Line No." := LineNoG + 10000;
                                            CostAllocationLineL."Project No." := DimentionValueL."code";
                                            ProductionPlanHeaderL.CalcFields("Recipe Cost");
                                            CostAllocationLineL."Recipe Cost" := ProductionPlanHeaderL."Recipe Cost";
                                            CostAllocationLineL.Insert(true);
                                            LineNoG += 10000;
                                        end else begin
                                            ProductionPlanHeaderL.CalcFields("Recipe Cost");
                                            CostAllocationLineL."Recipe Cost" += ProductionPlanHeaderL."Recipe Cost";
                                            CostAllocationLineL.Modify(true);
                                        end;
                                    until ProductionPlanHeaderL.Next() = 0;
                            until DimentionValueL.Next() = 0;
                        Commit();
                        TotalRecipeG := 0;

                        //Total recipe cost for % calculation
                        CostAllocationLineL.Reset();
                        CostAllocationLineL.setrange("From Date", "From Date");
                        CostAllocationLineL.setrange("To Date", "To Date");
                        CostAllocationLineL.setrange("Bulk Location", "Bulk Location");
                        if CostAllocationLineL.FindSet() then
                            repeat
                                TotalRecipeG += CostAllocationLineL."Recipe Cost";
                            until CostAllocationLineL.Next() = 0;
                        CostAllocationLineG.Reset();
                        CostAllocationLineG.setrange("From Date", "From Date");
                        CostAllocationLineG.setrange("To Date", "To Date");
                        CostAllocationLineG.setrange("Bulk Location", "Bulk Location");
                        if CostAllocationLineG.FindFirst() then
                            repeat
                                CostAllocationLineG."Allocation %" := (CostAllocationLineG."Recipe Cost" * 100) / TotalRecipeG;
                                CostAllocationLineG."Allocated Amount" := ("Bulk Allocation Cost" * CostAllocationLineG."Allocation %") / 100;
                                CostAllocationLineG."Allocated Cost Manual" := ("Bulk Allocation Cost" * CostAllocationLineG."Allocation %") / 100;
                                CostAllocationLineG.Modify();
                            until CostAllocationLineG.Next() = 0;
                        "Project Cost Allocation" := true;
                        if Modify() then
                            Message('Project Cost calculated');
                    end;
                }

            }
            group("General Journal Posting")
            {
                Caption = 'General Journal Posting';
                action(" Create General Journal")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Image = PostingEntries;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        TotalAmount: Decimal;
                    begin
                        if not "Project Cost Allocation" then
                            error('Run "Project Cost Allocation" first!');
                        if "Journal Posted" then
                            exit;
                        TotalAmount := 0;
                        CostAllocationLineG.Reset();
                        CostAllocationLineG.setrange("From Date", "From Date");
                        CostAllocationLineG.setrange("To Date", "To Date");
                        CostAllocationLineG.setrange("Bulk Location", "Bulk Location");
                        if CostAllocationLineG.FindFirst() then
                            repeat
                                TotalAmount += CostAllocationLineG."Allocated Cost Manual";
                            until CostAllocationLineG.Next() = 0;
                        if TotalAmount <> "Bulk Allocation Cost" then
                            Error('Allocated Cost Manual should be equal to Bulk Allocation Cost')
                        else begin
                            if not "Journal Created" then
                                GeneralLedgerPostingCodeunitL.CostAllocationToGenJournal(Rec);
                            // if Modify() then
                            Message('General Journal created');
                        end;

                    end;
                }
                action("Open General Journal")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Image = OpenJournal;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        LocationL: Record Location;
                        GenJournalLineL: Record "Gen. Journal Line";
                    begin
                        LocationL.Get("Bulk Location");
                        if LocationL."Location Type" = LocationL."Location Type"::" " then
                            exit;
                        GenJournalLineL.Reset();
                        GenJournalLineL.SetRange("Journal Template Name", LocationL."Journal Template Name");
                        GenJournalLineL.setrange("Journal Batch Name", LocationL."journal Batch Name");
                        if GenJournalLineL.FindFirst() then
                            Page.RunModal(39, GenJournalLineL)
                        else
                            Message('There is no lines in General Journal');
                    end;

                }
            }

        }
    }
    var
        CostAllocationLineG: record "Cost Allocation Line";
        ProductionPlanHeaderG: record "Production Plan Header";
        GeneralLedgerPostingCodeunitL: Codeunit "General Ledger Posting";

        LineNoG: Integer;
        TotalRecipeG: Decimal;
}