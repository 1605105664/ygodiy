--灵魂的觉醒
function c88990207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c88990207.target)
	e1:SetOperation(c88990207.activate)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c88990207.thtg)
	e2:SetOperation(c88990207.thop)
	c:RegisterEffect(e2)
end
function c88990207.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x281)~=0x281
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	return m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c88990207.matfilter(c)
	return not c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPIRIT) and c:IsFaceup() and c:IsAbleToHand()
end
function c88990207.matfilter2(c)
	return not c:IsType(TYPE_RITUAL) and c:IsFaceup() and c:IsAbleToHand() 
end
function c88990207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c88990207.matfilter2,tp,LOCATION_ONFIELD,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990207.matfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c88990207.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c88990207.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c88990207.matfilter2,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c88990207.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local mat=Duel.SelectMatchingCard(tp,c88990207.matfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		local matlvl=mat:GetFirst():GetRitualLevel(tc)
		mg:RemoveCard(mat:GetFirst())
		if matlvl<tc:GetLevel() then
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel()-matlvl,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.SendtoHand(mat,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c88990207.thfilter(c)
	return bit.band(c:GetType(),0x281)==0x281 and c:IsAbleToHand()
end
function c88990207.thfilter2(c)
	return not c:IsCode(88990207) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c88990207.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88990207.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88990207.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c88990207.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c88990207.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c88990207.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c88990207.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
