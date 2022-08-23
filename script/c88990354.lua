--集合坏兽 戴斯特巴尔
function c88990354.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0xd3),LOCATION_MZONE)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(c88990354.spcon)
	e1:SetOperation(c88990354.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP_ATTACK,0)
	e2:SetCondition(c88990354.spcon2)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1)
	e3:SetCondition(aux.dscon)
	e3:SetCost(c88990354.tgcost)
	e3:SetTarget(c88990354.tgtg)
	e3:SetOperation(c88990354.tgop)
	c:RegisterEffect(e3)
end
function c88990354.spfilter(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c88990354.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c88990354.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c88990354.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c88990354.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c88990354.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c88990354.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990354.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c88990354.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x37,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x37,2,REASON_COST)
end
function c88990354.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c88990354.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(math.ceil(g:GetFirst():GetBaseAttack()/2))
			c:RegisterEffect(e1)
		end
	end
end
