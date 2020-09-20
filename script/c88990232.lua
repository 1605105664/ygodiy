--天威之圣仙女
function c88990232.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,88990232)
	e1:SetCost(c88990232.descost)
	e1:SetTarget(c88990232.destg)
	e1:SetOperation(c88990232.desop)
	c:RegisterEffect(e1)
	--tohand/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c88990232.target)
	e2:SetOperation(c88990232.operation)
	c:RegisterEffect(e2)
end
function c88990232.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c88990232.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c88990232.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c88990232.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local g=Duel.GetMatchingGroup(c88990232.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c88990232.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88990232.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.Destroy(g,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(88990232,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c88990232.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x12c) and c:IsAbleToHand()
end
function c88990232.spfilter(c,e,tp)
	return not c:IsType(TYPE_EFFECT) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c88990232.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local sel=0
		if Duel.IsExistingMatchingCard(c88990232.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c88990232.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0 and e:GetHandler():GetFlagEffect(88990232)>0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(88990232,1),aux.Stringid(88990232,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(88990232,1))
	else
		Duel.SelectOption(tp,aux.Stringid(88990232,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c88990232.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88990232.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88990232.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
