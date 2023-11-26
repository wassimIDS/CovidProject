select location, date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2

--looking at total cases vs total deaths
select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2

--looking at total cases vs population
select location, date,total_cases,population, (total_cases/population)*100 as Percentage
from CovidDeaths
--where location like '%states%'
order by 1,2

--looking at countrries with highes infection rate
select location,max(total_cases) as highestInfectionCount,population, max((total_cases/population)*100) as Percentage
from CovidDeaths
--where location like '%states%'
group by population,location
order by 4 desc

--showing the countries with highes death count per popuation
select location,max(total_deaths) as totalDeathCount,population, max((total_cases/population)*100) as Percentage
from CovidDeaths
--where location like '%states%'
group by population,location
order by 4 desc

-- temp table
drop table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccintaions numeric,
rollingPeopleVaccinated numeric
)
insert into #percentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date )as rollingPeopleVAccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..covidvaccinations vac
on dea.location = vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select *, (rollingPeopleVaccinated/population)*100
from #percentPopulationVaccinated
-- creating view to store data for laater visualizaiton


create view percentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date )as rollingPeopleVAccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..covidvaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3









--looking at total population vs total vaccinations

with popVac (continent,location,date,population, new_vaccination, rollnigPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date )as rollingPeopleVAccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..covidvaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollnigPeopleVaccinated/population)*100
from popVac
