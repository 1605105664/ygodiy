--魔导兽 刻耳柏洛斯王
function c88990186.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),3)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x1)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c88990186.acop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c88990186.reptg)
	e3:SetValue(c88990186.repval)
	e3:SetOperation(c88990186.repop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c88990186.condition)
	e4:SetCost(c88990186.cost)
	e4:SetTarget(c88990186.target)
	e4:SetOperation(c88990186.operation)
	c:RegisterEffect(e4)
end
function c88990186.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,2)
	end
end
function c88990186.repfilter(c,e)
	return c==e:GetHandler() or c:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsRace(RACE_SPELLCASTER)
end
function c88990186.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) and eg:IsExists(c88990186.repfilter,1,nil,e)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c88990186.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x1,1,REASON_COST)
end
function c88990186.repval(e,c)
	return c88990186.repfilter(c,e)
end
function c88990186.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c88990186.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
end
function c88990186.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c88990186.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
