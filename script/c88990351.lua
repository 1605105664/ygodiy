--生命动力
function c88990351.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88990351+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c88990351.target)
	e1:SetOperation(c88990351.activate)
	c:RegisterEffect(e1)
end
function c88990351.filter(c)
	return c:GetAttack()>0 and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c88990351.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c88990351.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88990351.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c88990351.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
	if g:GetFirst():IsRace(RACE_DRAGON) then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	end
end
function c88990351.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT) and tc:IsRace(RACE_DRAGON) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
