--六花圣 尾花絮
function c88990288.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),4,2)
	c:EnableReviveLimit()
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,88990288)
	e1:SetCondition(c88990288.spcon)
	e1:SetTarget(c88990288.sptg)
	e1:SetOperation(c88990288.spop)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88990289)
	e2:SetCost(c88990288.rlcost)
	e2:SetTarget(c88990288.rltg)
	e2:SetOperation(c88990288.rlop)
	c:RegisterEffect(e2)
end
function c88990288.mfilter(c)
	return c:IsSetCard(0x141) and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c88990288.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetOverlayGroup():IsExists(c88990288.mfilter,1,nil)
end
function c88990288.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990288.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990288.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c88990288.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min(
		e:GetHandler():GetOverlayGroup():FilterCount(c88990288.mfilter,nil),
		Duel.GetLocationCount(tp,LOCATION_MZONE))
	local sg=Duel.GetMatchingGroup(c88990288.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if ct>0 and sg:GetCount()>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,ct,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88990288.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88990288.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST)
end
function c88990288.rlfilter(c)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(c88990288.thfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c88990288.thfilter(c,lv)
	return c:IsSetCard(0x141) and c:GetLevel()==lv and c:IsAbleToHand()
end
function c88990288.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990288.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) 
		and chkc:IsReleasableByEffect() and chkc:IsFaceup() 
		and e:GetHandler():GetLevel()==e:GetLabel() end
	if chk==0 then return Duel.IsExistingTarget(c88990288.rlfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c88990288.rlfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c88990288.rlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c88990288.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
