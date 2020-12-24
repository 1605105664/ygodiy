--混沌No.32 鲨龙兽 重铠装白煞
function c88990309.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),5,4,c88990309.ovfilter,aux.Stringid(88990309,0))
	c:EnableReviveLimit()
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c88990309.atcon)
	e1:SetOperation(c88990309.atop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88990309.mtcon)
	e2:SetCost(c88990309.mtcost)
	e2:SetTarget(c88990309.mttg)
	e2:SetOperation(c88990309.mtop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c88990309.repcon)
	e3:SetTarget(c88990309.reptg)
	c:RegisterEffect(e3)
end
c88990309.xyz_number=32
function c88990309.ovfilter(c)
	return c:IsFaceup() and c:IsRank(4) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c88990309.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) 
		and c:IsChainAttackable()
end
function c88990309.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c88990309.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0
end
function c88990309.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990309.filter(c,id)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_DESTROY) and c:GetTurnID()==id and c:IsCanOverlay()
end
function c88990309.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990309.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,Duel.GetTurnCount()) end
end
function c88990309.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c88990309.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c88990309.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,65676461)
end
function c88990309.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
