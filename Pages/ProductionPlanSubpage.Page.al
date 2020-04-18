page 50014 "Production Plan Subpage"
{

    PageType = ListPart;
    SourceTable = "Production Plan Line";
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
            action("Import Excel")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Import Excel';
                Caption = 'Import Excel';
                Image = ImportExcel;

                trigger OnAction()
                begin
                    ImportProductionLine();
                end;
            }
        }
    }
    var
        ExcelBuffer: Record "Excel Buffer";

    procedure ImportProductionLine()
    var
        ProductionPlanLineL: Record "Production Plan Line";
        TotalRow: Integer;
        RowNo: Integer;
        LineNo: Integer;
        Filename: Text;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;


    begin
        ProductionPlanLineL.Reset();
        ProductionPlanLineL.SetRange("Production Plan No.", "Production Plan No.");
        if ProductionPlanLineL.FindSet() then
            ProductionPlanLineL.DeleteAll();

        FileUploaded := UploadIntoStream('Select Timesheet to Upload', '', '', Filename, Instr);

        if Filename = '' then
            exit;

        ExcelBuffer.DeleteAll();
        ExcelBuffer.Reset();
        Sheetname := ExcelBuffer.SelectSheetsNameStream(Instr);
        ExcelBuffer.OpenBookStream(Instr, Sheetname);
        ExcelBuffer.ReadSheet();

        if ExcelBuffer.FindLast() then
            TotalRow := ExcelBuffer."Row No.";
        LineNo := 10000;
        for RowNo := 2 to TotalRow do begin
            ProductionPlanLineL.Init();
            evaluate(ProductionPlanLineL."Production Plan No.", GetValueAtIndex(RowNo, 1));
            ProductionPlanLineL."Line No." := LineNo;
            Evaluate(ProductionPlanLineL."Item No.", GetValueAtIndex(RowNo, 2));
            Evaluate(ProductionPlanLineL.Quantity, GetValueAtIndex(RowNo, 3));
            ProductionPlanLineL.Insert(true);
            LineNo += 10000;
        end;
        Message('%1 rows imported successfully !!!', TotalRow - 1);

    end;

    local procedure GetValueAtIndex(RowNoP: Integer; ColNoP: Integer): Text
    begin
        IF ExcelBuffer.Get(RowNoP, ColNoP) then
            exit(ExcelBuffer."Cell Value as Text");
    end;

}