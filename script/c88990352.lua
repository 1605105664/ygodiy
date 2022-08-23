--武装龙的咆哮
function c88990352.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88990352+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetCondition(c88990352.condition)
	e1:SetCost(c88990352.cost)
	e1:SetTarget(c88990352.target)
	e1:SetOperation(c88990352.activate)
	c:RegisterEffect(e1)
end
function c88990352.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c88990352.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88990352.spfilter(c,e,tp)
	return c:IsSetCard(0x111) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c88990352.desfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x111)
end
function c88990352.desfilter2(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c88990352.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990352.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c88990352.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88990352.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local dg=Duel.GetMatchingGroup(c88990352.desfilter2,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetAttack())
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP) 
		and not Duel.IsExistingMatchingCard(c88990352.desfilter,tp,LOCATION_MZONE,0,1,nil) and dg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
