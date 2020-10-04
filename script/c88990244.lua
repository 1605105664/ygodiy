--混沌No.89 电脑城 系统地狱
function c88990244.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c88990244.rmcost)
	e1:SetTarget(c88990244.rmtg)
	e1:SetOperation(c88990244.rmop)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c88990244.rmcon2)
	e2:SetTarget(c88990244.rmtg2)
	e2:SetOperation(c88990244.rmop2)
	c:RegisterEffect(e2)
end
c88990244.xyz_number=89
function c88990244.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990244.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN) 
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE+LOCATION_EXTRA)
end
function c88990244.rmfilter(c,tc)
	return c:IsFaceup() and c:IsAttribute(tc:GetAttribute()) and c:IsAbleToRemove()
end
function c88990244.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp,POS_FACEDOWN)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT) then
		Duel.ShuffleExtra(1-tp)
		local tc=sg:GetFirst()
		if Duel.IsExistingMatchingCard(c88990244.rmfilter,tp,0,LOCATION_MZONE,1,nil,tc) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,c88990244.rmfilter,tp,0,LOCATION_MZONE,1,1,nil,tc)
			Duel.HintSelection(rg)
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c88990244.rmfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_PSYCHO)
end
function c88990244.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and e:GetHandler():GetOverlayGroup():IsExists(c88990244.rmfilter2,1,nil)
end
function c88990244.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c88990244.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEDOWN,REASON_EFFECT)
	end
end
