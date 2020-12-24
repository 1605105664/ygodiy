--辉光圣 光子帕拉丁
function c88990315.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c88990315.lvtg)
	e1:SetValue(c88990315.lvval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88990315,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88990315)
	e2:SetLabel(2)
	e2:SetCost(c88990315.cost)
	e2:SetTarget(c88990315.thtg)
	e2:SetOperation(c88990315.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(88990315,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetLabel(3)
	e3:SetTarget(c88990315.sptg)
	e3:SetOperation(c88990315.spop)
	c:RegisterEffect(e3)
	--remove spell/trap
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(88990315,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetLabel(4)
	e4:SetTarget(c88990315.rmtg1)
	e4:SetOperation(c88990315.rmop1)
	c:RegisterEffect(e4)
	--remove monster
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(88990315,3))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetLabel(5)
	e5:SetTarget(c88990315.rmtg2)
	e5:SetOperation(c88990315.rmop2)
	c:RegisterEffect(e5)
end
function c88990315.lvtg(e,c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x55,0x7b)
end
function c88990315.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 4
	else return lv end
end
function c88990315.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function c88990315.thfilter(c)
	return c:IsSetCard(0x55,0x7b) and c:IsAbleToHand()
end
function c88990315.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88990315.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88990315.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88990315.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88990315.spfilter(c,e,tp)
	return c:IsSetCard(0x55,0x7b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990315.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88990315.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88990315.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88990315.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c88990315.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c88990315.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c88990315.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_MONSTER) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c88990315.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
