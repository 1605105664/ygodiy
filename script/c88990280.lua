--机甲精英骨架
function c88990280.initial_effect(c)
	aux.EnableUnionAttribute(c,c88990280.eqlimit)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88990280,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c88990280.eqtg)
	e1:SetOperation(c88990280.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88990280,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c88990280.sptg)
	e2:SetOperation(c88990280.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_EQUIP)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(2,88990280)
	e3:SetCondition(c88990280.thcon)
	e3:SetTarget(c88990280.thtg)
	e3:SetOperation(c88990280.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(2,88990280)
	e4:SetTarget(c88990280.thtg)
	e4:SetOperation(c88990280.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c88990280.eqlimit(e,c)
	return c:IsRace(RACE_MACHINE) or e:GetHandler():GetEquipTarget()==c
end
function c88990280.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and ct2==0
end
function c88990280.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88990280.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():GetFlagEffect(88990280)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c88990280.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c88990280.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(88990280,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c88990280.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c88990280.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c88990280.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(88990280)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(88990280,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c88990280.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c88990280.eqfilter(c,ec)
	return c==ec and c:GetEquipTarget():IsRace(RACE_MACHINE)
end
function c88990280.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88990280.eqfilter,1,nil,e:GetHandler())
end
function c88990280.thfilter(c)
	return c:IsSetCard(0x36) and c:GetCode()~=88990280 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88990280.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990280.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88990280.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88990280.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
