--命运女郎·盖蒂
function c88990355.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c88990355.value)
	c:RegisterEffect(e1)
	--cannot direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--choose
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,88990355)
	e4:SetTarget(c88990355.target)
	e4:SetOperation(c88990355.operation)
	c:RegisterEffect(e4)
end
function c88990355.atkfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x31)
end
function c88990355.value(e,c)
	local g=Duel.GetMatchingGroup(c88990355.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetLevel)*200
end
function c88990355.lvfilter(c)
	return c:IsFaceup() and not c:IsLevel(12) and c:GetLevel()>0
end
function c88990355.spfilter(c,e,tp)
	return c:IsSetCard(0x31) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990355.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():GetLinkedGroup():IsExists(c88990355.lvfilter,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990355.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88990355,0))
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(88990355,1),aux.Stringid(88990355,2))
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(88990355,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(88990355,2))
		op=1
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	end
end
function c88990355.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local c=e:GetHandler()
		local tc=c:GetLinkedGroup():FilterSelect(tp,c88990355.lvfilter,1,1,nil):GetFirst()
		if not tc then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(12)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88990355.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
