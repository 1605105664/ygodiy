--侵略的意志
function c88990307.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c88990307.condition)
	e1:SetTarget(c88990307.target)
	e1:SetOperation(c88990307.activate)
	c:RegisterEffect(e1)
end
function c88990307.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x100a)
end
function c88990307.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c88990307.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c88990307.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c88990307.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c88990307.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c88990307.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c88990307.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c88990307.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
