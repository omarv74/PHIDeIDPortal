using Azure.Search.Documents.Models;
using Azure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.FeatureManagement.Mvc;
using PhiDeidPortal.Ui.Services;
using PhiDeidPortal.Ui.Entities;
using IAuthorizationService = PhiDeidPortal.Ui.Services.IAuthorizationService;

namespace PhiDeidPortal.Ui.Pages
{
    [Authorize]
    [FeatureGate(Feature.ApprovedView)]
    public class CompletedModel(IAuthorizationService authorizationService, IAISearchService searchService, IFeatureService featureService) : PageModel
    {
        private readonly IAISearchService _searchService = searchService;
        private readonly IAuthorizationService _authService = authorizationService;
        private readonly IFeatureService _featureService = featureService;
        public Pageable<SearchResult<SearchDocument>>? Results { get; private set; }
        public bool IsDownloadFeatureAvailable { get; private set; }
        public bool IsDeleteFeatureAvailable { get; private set; }

        public void OnGet()
        {
            if (User.Identity?.Name is null) return;
            var viewFilter = Request.Query["v"].ToString().ToLower() == "me";
            var searchString = Request.Query["q"].ToString();
            var isElevated = _authService.HasElevatedRights(User);
            var searchFilter = $"status eq 4";

            Results = (isElevated && !viewFilter) ? _searchService.SearchAsync(searchFilter, searchString).Result : _searchService.SearchByAuthorAsync(User.Identity.Name, searchFilter, searchString).Result;
            IsDownloadFeatureAvailable = _featureService.IsFeatureEnabled(Feature.Download);
            IsDeleteFeatureAvailable = _featureService.IsFeatureEnabled(Feature.Delete);
        }
    }
}
