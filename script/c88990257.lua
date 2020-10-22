--神影依 乌洛波洛斯
--NEED REWORK
function c88990257.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c50907446.FShaddollCondition())
	e1:SetOperation(c50907446.FShaddollOperation())
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c50907446.splimit)
	c:RegisterEffect(e2)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,49820233)
	e1:SetCondition(c49820233.remcon)
	e1:SetTarget(c49820233.remtg)
	e1:SetOperation(c49820233.remop)
	c:RegisterEffect(e1)
end
function c50907446.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c49820233.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c49820233.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end

function c50907446.FShaddollFilter(c,fc)
	return c:IsFusionSetCard(0x9d) and c:IsCanBeFusionMaterial(fc)
end
function c50907446.FShaddollExFilter(c,fc)
	return c:IsFaceup() and c50907446.FShaddollFilter(c,fc)
end
function c50907446.FShaddollFilter1(c,g)
	return c:IsFusionSetCard(0x9d) and g:IsExists(c50907446.FShaddollFilter2,1,c) and not g:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end
function c50907446.FShaddollFilter2(c)
	return c:IsFusionSetCard(0x9d)
end
--------
function c50907446.FShaddollSpFilter1(c,fc,tp,mg,exg,chkf)
	return mg:IsExists(c50907446.FShaddollSpFilter2,1,c,fc,tp,c,chkf)
		or (exg and exg:IsExists(c50907446.FShaddollSpFilter2,1,c,fc,tp,c,chkf))
end
function c50907446.FShaddollSpFilter2(c,fc,tp,mc,chkf)
	local sg=Group.FromCards(c,mc)
	if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc) then return false end
---------
	return ((c50907446.FShaddollFilter1(c,sg) and c50907446.FShaddollFilter2(mc))
		or (c50907446.FShaddollFilter1(mc,sg) and c50907446.FShaddollFilter2(c)))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function c50907446.FShaddollCondition()
	return  function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local c=e:GetHandler()
			local mg=g:Filter(c50907446.FShaddollFilter,nil,c)
			local tp=e:GetHandlerPlayer()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				exg=Duel.GetMatchingGroup(c50907446.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c)
			end
			if gc then
				if not mg:IsContains(gc) then return false end
				return c50907446.FShaddollSpFilter1(gc,c,tp,mg,exg,chkf)
			end
			return mg:IsExists(c50907446.FShaddollSpFilter1,1,nil,c,tp,mg,exg,chkf)
		end
end
function c50907446.FShaddollOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local c=e:GetHandler()
			local mg=eg:Filter(c50907446.FShaddollFilter,nil,c)
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				exg=Duel.GetMatchingGroup(c50907446.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c)
			end
			local g=nil
			if gc then
				g=Group.FromCards(gc)
				mg:RemoveCard(gc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=mg:FilterSelect(tp,c50907446.FShaddollSpFilter1,1,1,nil,c,tp,mg,exg,chkf)
				mg:Sub(g)
			end
			if exg and exg:IsExists(c50907446.FShaddollSpFilter2,1,nil,c,tp,g:GetFirst(),chkf)
				and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
				fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=exg:FilterSelect(tp,c50907446.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,c50907446.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			end
			Duel.SetFusionMaterial(g)
		end
end

