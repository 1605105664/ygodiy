--正义盟军 决战头脑
function c88990256.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,88990256)
	e1:SetTarget(c88990256.sptg)
	e1:SetOperation(c88990256.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c88990256.immcon)
	e3:SetOperation(c88990256.immop)
	c:RegisterEffect(e3)
end
function c88990256.spfilter(c,e,tp)
	return c:IsSetCard(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990256.afilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c88990256.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990256.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c88990256.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_LIGHT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c88990256.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local ct=math.min(
		Duel.GetMatchingGroupCount(c88990256.afilter,tp,0,LOCATION_ONFIELD,nil),
		Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if tg:GetClassCount(Card.GetCode)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=tg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c88990256.immcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():GetLevel()>=10
end
function c88990256.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88990256,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c88990256.efilter)
	rc:RegisterEffect(e1,true)
end
function c88990256.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
