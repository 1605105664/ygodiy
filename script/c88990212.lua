--精灵兽 地兔
function c88990212.initial_effect(c)
	c:SetSPSummonOnce(88990212)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88990212,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c88990212.descost)
	e1:SetTarget(c88990212.destg)
	e1:SetOperation(c88990212.desop)
	c:RegisterEffect(e1)
end
function c88990212.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb5) and c:IsAbleToRemoveAsCost()
end
function c88990212.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990212.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c88990212.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c88990212.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c88990212.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
