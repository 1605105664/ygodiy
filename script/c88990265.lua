--光道苦行者 索恩
function c88990265.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,88990265)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c88990265.sptg)
	e1:SetOperation(c88990265.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,88990266)
	e2:SetTarget(c88990265.thtg)
	e2:SetOperation(c88990265.thop)
	c:RegisterEffect(e2)
	--discard deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c88990265.discon)
	e3:SetTarget(c88990265.distg)
	e3:SetOperation(c88990265.disop)
	c:RegisterEffect(e3)
end
function c88990265.spfilter(c,e,tp)
	return c:IsSetCard(0x38) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88990265.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanDiscardDeck(tp,2)
		and Duel.IsExistingMatchingCard(c88990265.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,tp,2)
end
function c88990265.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88990265.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.DiscardDeck(tp,2,REASON_EFFECT)
	end
end
function c88990265.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x38) and c:IsAbleToHand()
end
function c88990265.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c88990265.thfilter(chkc) end
	if chk==0 then 
		if ft<0 or not e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		if ft==0 then
			return Duel.IsExistingTarget(c88990265.thfilter,tp,LOCATION_MZONE,0,1,nil)
		else
			return Duel.IsExistingTarget(c88990265.thfilter,tp,LOCATION_ONFIELD,0,1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SelectTarget(tp,c88990265.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		local g=Duel.SelectTarget(tp,c88990265.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88990265.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
		and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c88990265.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c88990265.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c88990265.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
