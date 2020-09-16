--古代的上级素体
function c88990221.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88990221,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c88990221.ntcon)
	e1:SetOperation(c88990221.ntop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88990221,1))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,88990221)
	e2:SetTarget(c88990221.tg)
	e2:SetOperation(c88990221.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c88990221.aclimit)
	e4:SetCondition(c88990221.actcon)
	c:RegisterEffect(e4)
end
function c88990221.cfilter(c)
	return (c:IsFacedown() or not c:IsRace(RACE_MACHINE)) and c:IsType(TYPE_MONSTER)
end
function c88990221.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c88990221.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c88990221.thfilter(c)
	return c:IsSetCard(0x7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c88990221.spfilter(c,e,tp)
	return c:IsSetCard(0x7) and not c:IsCode(88990221) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990221.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c88990221.thfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c88990221.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88990221,1))
		sel=Duel.SelectOption(tp,aux.Stringid(88990221,2),aux.Stringid(88990221,3))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(88990221,2))
	else
		Duel.SelectOption(tp,aux.Stringid(88990221,3))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c88990221.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c88990221.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88990221.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c88990221.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c88990221.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
