--盟军·次世代双武人
function c88990339.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88990339,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88990339)
	e1:SetCost(c88990339.cost)
	e1:SetTarget(c88990339.distg)
	e1:SetOperation(c88990339.disop)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88990339,1))
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMINGS_CHECK_MONSTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,88990339)
	e2:SetCost(c88990339.cost)
	e2:SetTarget(c88990339.antg)
	e2:SetOperation(c88990339.anop)
	c:RegisterEffect(e2)
end
function c88990339.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local cg=Duel.DiscardHand(tp,Card.IsDiscardable,1,2,REASON_COST+REASON_DISCARD,nil)
	e:SetLabel(cg)
end
function c88990339.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local at=Duel.AnnounceAttribute(tp,e:GetLabel(),ATTRIBUTE_ALL)
	e:SetLabel(at)
end
function c88990339.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetLabel(e:GetLabel())
	e1:SetTarget(c88990339.distg2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(c88990339.atkval)
	Duel.RegisterEffect(e2,tp)
end
function c88990339.distg2(e,c)
	return c:IsFaceup() and c:IsAttribute(e:GetLabel())
end
function c88990339.atkval(e,c)
	return c:GetAttack()/2
end
function c88990339.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local at=Duel.AnnounceRace(tp,e:GetLabel(),RACE_ALL)
	e:SetLabel(at)
end
function c88990339.anop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetLabel(e:GetLabel())
	e1:SetTarget(c88990339.antg2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetValue(c88990339.fuslimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(1)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e5:SetValue(1)
	Duel.RegisterEffect(e5,tp)
end
function c88990339.antg2(e,c)
	return c:IsFaceup() and c:IsRace(e:GetLabel())
end
function c88990339.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
