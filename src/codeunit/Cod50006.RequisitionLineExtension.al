codeunit 50006 "Requisition Line Extension"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnGetLocationCodeOnBeforeUpdate', '', true, true)]
    local procedure OnGetLocationCodeOnBeforeUpdate(var RequisitionLine: Record "Requisition Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        VendL: Record Vendor;
    begin
        with RequisitionLine do begin
            if "Vendor No." = '' then begin
                IsHandled := true;
                exit;
            end;
            if VendL.Get("Vendor No.") then
                if VendL."Location Code" = '' then
                    IsHandled := true;
        end;
    end;
}