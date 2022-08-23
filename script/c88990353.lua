--黑蝎-奇袭的卡夫卡
function c88990353.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c88990353.sptg)
	e1:SetOperation(c88990353.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--choose
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c88990353.condition)
	e3:SetTarget(c88990353.target)
	e3:SetOperation(c88990353.operation)
	c:RegisterEffect(e3)
end
function c88990353.spfilter(c,e,sp)
	return (c:IsCode(76922029) or not c:IsCode(88990353) and c:IsSetCard(0x1a)) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c88990353.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990353.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88990353.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c88990353.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
end
function c88990353.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c88990353.tgfilter(c)
	return c:IsSetCard(0x1a) and c:IsAbleToGrave()
end
function c88990353.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
	local b2=Duel.IsExistingMatchingCard(c88990353.tgfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88990353,0))
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(88990353,1),aux.Stringid(88990353,2))
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(88990353,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(88990353,2))
		op=1
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function c88990353.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88990353,3))
		local sg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):Select(1-tp,1,1,nil)
		if #sg<=0 then return end
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c88990353.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.HintSelection(g)
				Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
			end
		end
	end
end
