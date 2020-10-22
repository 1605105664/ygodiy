--超银河眼残光龙
function c88990254.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(c88990254.raval)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c88990254.spcon)
	e2:SetCost(c88990254.spcost)
	e2:SetTarget(c88990254.sptg)
	e2:SetOperation(c88990254.spop)
	c:RegisterEffect(e2)
end
function c88990254.atkfilter(c)
	return c:IsSetCard(0x7b) or c:IsSetCard(0x55)
end
function c88990254.raval(e,c)
	return e:GetHandler():GetOverlayGroup():FilterCount(c88990254.atkfilter,nil)
end
function c88990254.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget()
end
function c88990254.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990254.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c88990254.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990254.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88990254.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c88990254.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0
		and tc:IsRelateToEffect(e) 
		and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1*math.ceil(sc:GetBaseAttack()))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-1*math.ceil(sc:GetBaseDefense()))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
