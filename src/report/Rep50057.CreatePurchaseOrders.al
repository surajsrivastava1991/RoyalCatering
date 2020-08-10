report 50057 "Create Purchase Orders"
{
    Caption = 'Create Purchase Orders';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
    }
    trigger OnPreReport()
    begin
        IndentLineG.SetCurrentKey("Vendor No.", "Currency Code", "No.");
        CheckLinesMandatoryFields(IndentLineG);
        IndentHdrG.Carryoutaction(IndentHdrG, IndentLineG);
    end;

    procedure InitIndnetHeader(var IndentHeaderP: Record "Purchase Indent Header")
    begin
        IndentHdrG.Copy(IndentHeaderP);
    end;

    procedure InitIndentLine(var IndentLineP: Record "Purchase Indent Line")
    begin
        IndentLineG.Copy(IndentLineP);
    end;

    procedure CheckLinesMandatoryFields(var IndentLineP: Record "Purchase Indent Line")
    var
        IndentLineL: Record "Purchase Indent Line";
    begin
        IndentLineL.Copy(IndentLineP);
        if IndentLineL.FindSet() then
            repeat
                IndentLineL.TestField("No.");
                IndentLineL.TestField("Vendor No.");
                IndentLineL.TestField(Quantity);
            until IndentLineL.next() = 0;
    end;

    var
        RequisitionLineG: Record "Requisition Line";
        IndentHdrG: Record "Purchase Indent Header";
        IndentLineG: Record "Purchase Indent Line";
        PurchaseSetup: Record "Purchases & Payables Setup";
        LineNoG: Integer;
}