codeunit 50052 "Requi. Price Calc."
{
    var
        Vend: Record Vendor;
        Item: Record Item;
        PriceInSKU: Boolean;
        TempPurchPrice: Record "Purchase Price" temporary;
        FoundPurchPrice: Boolean;
        SKU: Record "Stockkeeping Unit";

    procedure FindReqLinePrice(var ReqLine: Record "Purchase Indent Line"; CalledByFieldNo: Integer)
    var
        VendorNo: Code[20];
        IsHandled: Boolean;
    begin
        with ReqLine do
            if Type IN [Type::Item, Type::"Item(Service)"] then begin
                if not Vend.Get("Vendor No.") then
                    Vend.Init
                else
                    if Vend."Pay-to Vendor No." <> '' then
                        if not Vend.Get(Vend."Pay-to Vendor No.") then
                            Vend.Init;
                if Vend."No." <> '' then
                    VendorNo := Vend."No."
                else
                    VendorNo := "Vendor No.";
                Item.Get("No.");
                PriceInSKU := SKU.Get("Receiving Location", "No.", "Variant Code");
                IsHandled := false;
                if not IsHandled then
                    FindPurchPrice(
                      TempPurchPrice, VendorNo, "No.", "Variant Code",
                      "Unit of Measure Code", "Currency Code", "Creation Date", false);
                CalcBestDirectUnitCost(TempPurchPrice, ReqLine);
                if FoundPurchPrice or
                   not ((CalledByFieldNo = FieldNo(Quantity)) or
                        ((CalledByFieldNo = FieldNo("Variant Code")) and not PriceInSKU))
                then
                    "Direct Unit Cost" := TempPurchPrice."Direct Unit Cost";
            end;
    end;

    local procedure CalcBestDirectUnitCost(var PurchPrice: Record "Purchase Price"; var ReqLineP: Record "Purchase Indent Line")
    var
        BestPurchPrice: Record "Purchase Price";
        IsHandled: Boolean;
        BestPurchPriceFound: Boolean;
    begin
        with PurchPrice do begin
            ReqLineP."Trade agreement exist" := false;
            FoundPurchPrice := Find('-');
            if FoundPurchPrice then
                repeat
                    case true of
                        ((BestPurchPrice."Currency Code" = '') and ("Currency Code" <> '')) or
                        ((BestPurchPrice."Variant Code" = '') and ("Variant Code" <> '')):
                            begin
                                BestPurchPrice := PurchPrice;
                                BestPurchPriceFound := true;
                                ReqLineP."Trade agreement exist" := true;
                                ReqLineP.Validate("Trade agreement exist");
                            end;
                        ((BestPurchPrice."Currency Code" = '') or ("Currency Code" <> '')) and
                      ((BestPurchPrice."Variant Code" = '') or ("Variant Code" <> '')):
                            if (BestPurchPrice."Direct Unit Cost" = 0) or
                               (CalcLineAmount(BestPurchPrice) > CalcLineAmount(PurchPrice))
                            then begin
                                BestPurchPrice := PurchPrice;
                                BestPurchPriceFound := true;
                                ReqLineP."Trade agreement exist" := true;
                                ReqLineP.Validate("Trade agreement exist");
                            end;
                    end;
                until Next = 0;
        end;
        // No price found in agreement
        if not BestPurchPriceFound then begin
            IsHandled := false;
            if not IsHandled then begin
                PriceInSKU := PriceInSKU and (SKU."Last Direct Cost" <> 0);
                if PriceInSKU then
                    BestPurchPrice."Direct Unit Cost" := SKU."Last Direct Cost"
                else
                    BestPurchPrice."Direct Unit Cost" := Item."Last Direct Cost";
            end;
            ReqLineP."Trade agreement exist" := false;
            ReqLineP.Validate("Trade agreement exist");
        end;

        PurchPrice := BestPurchPrice;
    end;


    procedure FindPurchPrice(var ToPurchPrice: Record "Purchase Price"; VendorNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromPurchPrice: Record "Purchase Price";
    begin

        with FromPurchPrice do begin
            SetRange("Item No.", ItemNo);
            SetRange("Vendor No.", VendorNo);
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            if not ShowAll then begin
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            end;

            ToPurchPrice.Reset;
            ToPurchPrice.DeleteAll;
            if Find('-') then
                repeat
                    ToPurchPrice := FromPurchPrice;
                    ToPurchPrice.Insert;
                until Next = 0;
        end;

    end;

    local procedure CalcLineAmount(PurchPrice: Record "Purchase Price"): Decimal
    begin
        with PurchPrice do
            exit("Direct Unit Cost");
    end;
}