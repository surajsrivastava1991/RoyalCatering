table 50001 "Production Plan Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Production Plan No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item where("BEO Item Type" = filter('Recipe Item'));
            trigger OnValidate()
            var
                ItemL: Record Item;
            begin
                if ItemL.Get("Item No.") then begin
                    Description := ItemL.Description;
                    UOM := ItemL."Production Unit of Measure";
                end else begin
                    Description := '';
                    UOM := '';
                end;
            end;
        }
        field(4; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; UOM; code[10])
        {
            DataClassification = CustomerContent;
            tablerelation = "Item Unit of Measure" where("Item No." = field("Item No."));
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Recipe Cost" <> 0 then
                    "Line Amount" := "Recipe Cost" * Quantity;
            end;
        }
        field(7; "Recipe Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                if "Quantity" <> 0 then
                    "Line Amount" := "Recipe Cost" * Quantity;
            end;
        }
        field(8; "Calculation Standard Cost"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Cal. Standard Cost Run Date"; Date)
        {
            Caption = 'Calculation Standard Cost RUN Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Recipe Cost(Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            var
                ItemUnitOfmeasureL: Record "Item Unit of Measure";
            begin
                TestField("Item No.");
                TestField(UOM);
                ItemUnitOfmeasureL.Reset();
                ItemUnitOfmeasureL.SetRange("Item No.", "Item No.");
                ItemUnitOfmeasureL.SetRange(Code, UOM);
                if ItemUnitOfmeasureL.FindFirst() then
                    validate("Recipe Cost", "Recipe Cost(Base)" * ItemUnitOfmeasureL."Qty. per Unit of Measure")
                else
                    Error('Please define Unit of measure which you have given in Production Plan %1 for Item No. %2, line No. %3', "Production Plan No.", "Item No.", "Line No.");


            end;
        }
    }

    keys
    {
        key(PK; "Production Plan No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
        ProductionPlanHeaderG.Reset();
        ProductionPlanHeaderG.SetRange("Production Plan No.", "Production Plan No.");
        if ProductionPlanHeaderG.FindFirst() then
            if ProductionPlanHeaderG.Status = ProductionPlanHeaderG.Status::Finished then
                Error('Production Plan has been posted');
    end;

    trigger OnDelete()
    begin


    end;

    trigger OnRename()
    begin

    end;

    var
        ProductionPlanHeaderG: Record "Production Plan Header";

}