--核成将军
function c88990264.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c88990264.mtcon)
	e1:SetOperation(c88990264.mtop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88990264.thcon)
	e2:SetTarget(c88990264.thtg)
	e2:SetOperation(c88990264.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c88990264.spcost)
	e3:SetTarget(c88990264.sptg)
	e3:SetOperation(c88990264.spop)
	c:RegisterEffect(e3)
end
function c88990264.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c88990264.cfilter1(c)
	return c:IsCode(36623431) and c:IsAbleToGraveAsCost()
end
function c88990264.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and not c:IsPublic()
end
function c88990264.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c88990264.cfilter1,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c88990264.cfilter2,tp,LOCATION_HAND,0,nil)
	local select=2
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88990264,0),aux.Stringid(88990264,1),aux.Stringid(88990264,2))
	elseif g1:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88990264,0),aux.Stringid(88990264,2))
		if select==1 then select=2 end
	elseif g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88990264,1),aux.Stringid(88990264,2))+1
	else
		select=Duel.SelectOption(tp,aux.Stringid(88990264,2))
		select=2
	end
	if select==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif select==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g2:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function c88990264.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c88990264.thfilter(c)
	return c:IsSetCard(0x1d) and c:IsAbleToHand()
end
function c88990264.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990264.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88990264.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88990264.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88990264.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990264.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990264.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990264.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c88990264.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88990264.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
